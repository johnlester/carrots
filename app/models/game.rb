class Game
  include DataMapper::Resource
  
  property :id, Serial
  property :round, Integer, :default => 1
  property :active?, Boolean, :default => false
  property :finished?, Boolean, :default => false
  has n, :characters
  has n, :moves, :class_name => "Move"
  
  def initialize(character_id)    
    character = Character.get(character_id)
    self.characters << character
    self.save
  end
  
  def Game.create_random
    new_game = Game.create
    
    #create two new characters and add to new game
    char_one = Character.create_random
    new_game.characters << char_one
    char_two = Character.create_random
    new_game.characters << char_two    
    new_game.save
    
    #create cards for each character
    char_one.add_random_cards(10)
    char_two.add_random_cards(10)
    
    return new_game
    
  end

  def do_round
    # check to see if both players have an unprocessed move in database
    # if not, do nothing and report failure
    return false unless ready_to_do_round?
    
    # if so, do the moves and store the results
    apply_round_effects
    
  end
  
  # Have all characters in this game finalizing their moves for this round?
  # For each character that has finalized their moves, 
  # character.last_round_input should equal game.round
  def ready_to_do_round?
    # do all players have an unprocessed move in the database?
    result = true
    self.characters.each do |character|
      result = result && (character.last_round_input == self.round)
    end
    return result
  end
  
  def current_moves
    self.moves.all(:round_played => self.round)
  end
  
  def current_effects
    current_effects = []
    
    #effects from cards played in prior rounds
    
    # effects from current_moves with timing = 0 (this round)
    current_moves.each do |move|
      move.card.card_effects.each do |effect|
        if effect.timing == 0
          current_effects << effect
        end
      end
    end
    
    return current_effects
  end
  
  def active_effects
    # determine active effects
    active_effects = []

    current_effects.each do |effect|
      active_effects << effect
    end
    
    # knock out canceled effects
    
    
    return active_effects
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

  def target(origin)
    self.characters.first(:id.not => origin.id)
  end

  def apply_round_effects
    round_effects.each do |character_id, effect_hash|
      self.characters.first(:id => character_id).apply_effects(effect_hash)
    end
    
  end

  # for interactive shell testing
  def do_random_moves
    self.characters.each do |character|
      character.do_random_move
    end
  end

end
