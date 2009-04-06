class Game
  include DataMapper::Resource
  
  property :id, Serial
  property :round, Integer, :default => 0
  property :finished, Boolean, :default => false
  property :play_order, Yaml
  property :play_history, Yaml, :default => [[]]  # play_history[round][turnstep] = {}
  property :turn_step, Integer, :default => 0
  
  has n, :characters
  
  
  def Game.start_game(list_of_characters = [])
    new_game = Game.new
    order = []
    list_of_characters.each do |character|     
      new_game.characters << character
      order << character.id
    end
    new_game.play_order = order.sort_by {rand}
    new_game.play_order << :round_end
    new_game.play_history = [[]]
    new_game.save!
    return new_game
  end

  ################# round order functions
  def current_character
    self.characters.get!(self.play_order[0])    
  end

  def move_to_next_character
    self.play_order << self.play_order.shift
    self.turn_step += 1
    
    # if round end, increment round
    if self.play_order[0] == :round_end
      self.play_order << self.play_order.shift
      # TO DO: call round end effects
      self.round += 1
      self.turn_step = 0
    end
    self.save!
    current_character_options
  end

  ##################### do round functions
  
  # Game states:
  # just created: round = 0, turn_step = 0, play_history = [[]]
  # call current_character_options: play_history[round = 0][turn_step = 0] = {:options, :id, :results = false, :selection}
  # 
  
  def update_game
    loop do
      break unless current_character_selection
      process_turn       
      move_to_next_character
    end    
    # if current character has no input and is not a npc
    return false
  end

  ################### option-creation functions  
  def current_character_selection
    if current_character_options[:selection]
      return current_character_options[:selection]
    end    
    if current_character.npc
      current_character_options[:selection] = make_npc_selection
      self.save!
      return current_character_options[:selection]
    else  # player character
      return false
    end
  end
  
  def current_character_options
    # make options for current character and store (unless already made)
    unless self.play_history[self.round][self.turn_step]
      self.play_history[self.round][self.turn_step] = {:effect_results_list => generate_options(current_character), :origin_id => current_character.id, :selection => false}
      self.save!      
    end    
    return self.play_history[self.round][self.turn_step]
  end

  def effect_result(effect)
    targets.each do |target|
      effect[:target] = target
    return origin.send_effect()
  end
  
  def generate_options(character)
    results = []
    number_of_options = 2
    duplicate_options = 0
    power_instance_list = available_power_instances(character)
    option_frequencies = power_instance_list.map {|power| power.option_frequency}
    enemy_targets = enemies_of(character) # may need just-in-time target selection for some powers
    ally_targets = allies_of(character)
    while (results.size < number_of_options) and (duplicate_options < 100)     
      # add option to result
      new_option = PowerOption.new(power_instance_list.random(option_frequencies))
      new_option.effect_targets = []
      new_option.effects.each do |effect|
        case effect[:target_type]
        when :single_enemy
          new_option.effect_targets << enemy_targets.random.id
        end
      end          
      # check to see if it is a duplicate of existing options
      # if duplicate
        #duplicate_options += 1
      # else    
      results << new_option      
    end    
    return results
  end

  def available_power_instances(character)
    result = []
    #personal powers, from gear or character
    character.character_powers.each do |power|
      #test to see if can be used
      can_be_used = true
      
      result << power if can_be_used      
    end
    #location powers
    
    return result
  end

  def enemies_of(character)
    #returns array of character id's
    self.characters.all(:party.not => character.party)
  end

  def allies_of(character)
    #returns array of character i
    self.characters.all(:party => character.party)
  end
  



  # current_character_options[:results] = [{:target = char_id, :result = {:result_type = :damage, :amount = 10}}]
  def process_turn
    current_character_options[:results].each do |result|
      self.characters.get(result[:target]).do_result(result[:result])
    end
  end  

  # def process_turn
  #   return false if current_character_options[:results] # already processed
  #   results = []
  #   option_to_do = current_character_options[:options][current_character_options[:selection]]
  #   option_to_do.effects.each do |effect|
  #     #establish targets
  #     case effect[:target_type]
  #     when :single_enemy
  #       targets = [self.characters.get(option_to_do.effect_targets.shift)]
  #     end #case
  #     # origin translations
  #     # send to targers
  #     targets.each do |target|
  #       target.
  #   end
  # end
  
  # returns description of effects  
  # def do_effect(effect)
  #   result = []
  #   # {:effect_type=>:damage, :target_type=>:single_enemy, :damage_type=>:shadow, :base_amount=>25}
  #   case effect[:target_type]
  #   when :single_enemy
  #     targets = [self.characters.get()]
  #   
  #   # get effect type
  #   # get character
  #   # get modifiers from character for effect type
  #   # calculate total effect
  #   # send effect to each target
  #   # receive final effect from target
  # end


  
  def pc_select(selection)
    current_character_options[:selection] = selection
    self.save!
  end
  
  def make_npc_selection
    # returns selection
  end
  

  #returns array of characters (or maybe character.ids)
  # def power_targets(options)
  #   # options[:origin] = character that power is originating from
  #   # options[:target_type] = :all_enemies
  #   #                         :single_enemy
  #   #                         :self 
  #   #                         :single_ally
  #   #                         :single_ally_not_self
  #   #                         :all_allies
  #   #                         :lowest_health
  #   
  # end

  # round_effects returns a hash of hashes: {character.id => {:fire => fire damage to character}}  
  def round_effects
    # populate round_effects with character id's    
    round_effects = {}
    self.characters.each do |character|
      round_effects[character.id] = {}
    end
    
    # determine aggregate damages for each character, net of blocking
    active_effects.each do |active_effect|
      target_id = target(active_effect.origin).id
      effect = active_effect.effect
      amount = active_effect.amount

      case effect
      when :fire, :shadow, :physical
        if round_effects[target_id][effect]
          round_effects[target_id][effect] += amount
        else
          round_effects[target_id][effect] = amount
        end
      when :fire_blocking, :shadow_blocking, :physical_blocking
        effect_blocked =  case effect
                          when :fire_blocking: :fire
                          when :shadow_blocking: :shadow
                          when :physical_blocking: :physical
                          end
        if round_effects[target_id][effect_blocked]
          round_effects[target_id][effect_blocked] -= amount
        else
          round_effects[target_id][effect_blocked] = -amount
        end
      else #effect not found, so raise error
        raise
      end
      
    end
    
    # eliminate negative and zero damages
    round_effects.each do |character_id, effect_hash|
      effect_hash.delete_if { |effect_type, amount| amount <= 0 }
    end
    
    # apply multiplicative modifiers to base damages
    
    # do round-end effects (e.g. conversions)
    
    # calculate final damage
    
    # return damage totals
    
    return round_effects
  end


  def apply_round_effects
    round_effects.each do |character_id, effect_hash|
      self.characters.first(:id => character_id).apply_effects(effect_hash)
    end
    
  end


end
