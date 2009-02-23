# Forms:
# in file, human readable (name, generic effect in text, conditions)
# list to be attached to new gear (name, types of gear)
# on-gear link (name, level)
# listing presented to user (name, specific effect in text)
# to be processed in game (character, target list, effect in code, )
#   Power class (or module)
#   List of effects.Each effect
#     determine affected characters
#     each affected character
#       send effect to char

class Power
  include DataMapper::Resource
  
  property :id, Serial

  property :name, String
  property :level, Integer
  property :effects, Yaml

  
  belongs_to :character
  belongs_to :game
  
  def description
    
  end
  
  # effect = {:target_type => :single_enemy
  #           :target_list => [id_one]
  #           :effect_type => :damage_consume_stackable
  #           :stackable_name => :positioning
  #           :damage_type => :physical
  #           :base => 10
  #           :per_stackable => 5}

  # effect = {:target_type => :all_enemies
  #           :target_list => [id_one, id_two]
  #           :effect_type => :fixed_damage_add_stackable
  #           :damage_type => :fire
  #           :base => 50
  #           :stackable_name => :darkened_soul

end
