class Game
  include DataMapper::Resource
  
  property :id, Serial
  property :round, Integer, :default => 1
  property :finished?, Boolean, :default => false
  property :play_order, Yaml
  
  has n, :characters
  
  
  def initialize(list_of_characters = [])    
    order = []
    list_of_characters.each do |character|     
      self.characters << character
      order << character.id
    end
    self.play_order = order.sort_by {rand}
    self.play_order << :round_end
    self.save
  end

  def current_character
    self.characters.get!(self.play_order[0])    
  end

  def move_to_next_character
    self.play_order << self.play_order.shift
    
    # if round end, increment round
    if self.play_order[0] == :round_end
      self.play_order << self.play_order.shift
      # TO DO: call round end effects
      self.round += 1
    end
    self.save
  end

  def available_powers(character)
    result = []
    #personal powers, from gear or character
    character.character_powers.each do |power|
      #test to see if can be used
      can_be_used = true
      
      result << power if can_be_used?
      
    end
    
    #location powers
    
    
    return result
  end
  
  def create_options(character)
    results = []
    number_of_options = 2
    options_tried = 0
    
    while results.size < number_of_options
    
      # add option to result
      options_tried += 1
    
    
      # check to remove any duplicate options
    
    end
    
    return results
  end

  def enemies_of(character)
    #returns list of enemies
  end
  
  def do_power(power)    
    power.effects.each do |effect|
      do_effect(effect)
    end
  end


  def do_effect(effect)
    # get effect type
    # get character
    # get modifiers from character for effect type
    # calculate total effect
    # send effect to each target
    # receive final effect from target
  end

  #returns array of characters (or maybe character.ids)
  def power_targets(options)
    # options[:origin] = character that power is originating from
    # options[:target_type] = :all_enemies
    #                         :single_enemy
    #                         :self 
    #                         :single_ally
    #                         :single_ally_not_self
    #                         :all_allies
    #                         :lowest_health
    
  end

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
