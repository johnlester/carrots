class Move
  include DataMapper::Resource
  
  property :id, Serial
  property :round_played, Integer
  belongs_to :character
  belongs_to :game
  belongs_to :card

  def initialize(character, card)
    self.character = character
    self.card = card
    self.game = character.game
    self.round_played = character.game.round
    self.save
    return self
  end
  
end
