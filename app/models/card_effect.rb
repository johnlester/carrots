class CardEffect
  include DataMapper::Resource
  
  property :id, Serial
  property :effect, Enum[:fire, :shadow, :physical, :fire_blocking, :shadow_blocking, :physical_blocking]
  property :amount, Integer
  property :timing, Integer #zero is this round, one is next round, etc.
  
  belongs_to :card
  
  # def initialize(effect, amount, timing)
  #   self.effect = effect
  #   self.amount = amount
  #   self.timing = timing
  #   self.save
  # end

  def origin
    self.card.character
  end

  

end
