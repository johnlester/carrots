class Card
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String

  belongs_to :character

  has n, :card_effects
  
  def initialize
    
  end

  def Card.create_random
    
    new_card = Card.new
    
    #random name
    name_style = NameStyle.first || NameStyle.create
    new_card.name = name_style.random
    
    #this round effects
    this_round_effect_types = {:direct_damage => 1000, :damage_blocking => 600}
    case this_round_effect_types.random

    when :direct_damage
    effect = {:fire => 100, :shadow => 100, :physical => 200}.random
    amount = {10 => 100, 15 => 50, 20 => 30, 30 => 20, 50 => 10}.random

    when :damage_blocking
    effect = {:fire_blocking => 150, :shadow_blocking => 50, :physical_blocking => 200}.random
    amount = {10 => 100, 15 => 30, 20 => 15, 30 => 10, 50 => 2}.random
      
    end
    new_card.card_effects.build(:effect => effect, :amount => amount, :timing => 0)    


    new_card.save
    return new_card
    
  end


end
