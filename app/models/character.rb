class Character
  include DataMapper::Resource
  
  
  property :id, Serial
  property :name, String
  property :max_health, Integer, :default => 100
  property :health, Integer, :default => 100
  property :last_round_input, Integer, :default => 0
  
  belongs_to :user
  belongs_to :game
  has n, :cards
  has n, :moves, :class_name => "Move"

  def Character.create_random
    new_character = Character.new

    #random name
    name_pattern = NamePattern.first || NamePattern.create([:start_cons, :simple_vowels, :mid_cons, :endings])
    new_character.name = name_pattern.random
    
    new_character.save
    return new_character
  end
  
  def add_random_cards(number = 1)
    number.times do
      cards << Card.create_random
    end
    save
  end
  
  def complete_input_for_this_round
    if current_moves.count >= 1
      self.last_round_input += 1
      self.save
    else
      raise
    end    
  end
  
  def this_game_moves
    moves.all(:game_id => self.game.id)
  end
  
  def current_moves
    moves.all(:game_id => self.game.id, :round_played => self.game.round)
  end
  
  def round_input_done?
    self.last_round_complete_input == self.game.round
  end
  
  def do_move(card)
    #check to make sure card is in character's hand and can be played
    
    #add card to moves
    Move.new(self, card)
    
  end
  
  def do_random_move
    do_move(cards[rand(cards.count)])
  end
  
  def apply_effects(effect_hash)
    # effect_hash of form {:fire => fire damage to character, :physical => physical damage to character}
    effect_hash.each do |effect_type, amount|
      take_damage(amount)
    end
    
  end
  
  def take_damage(amount)
    if amount >= self.health
      self.health = 0
    else
      self.health -= amount
    end
    self.save
  end
  
end