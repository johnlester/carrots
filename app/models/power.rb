# Forms:
# in file, human readable (name, generic effect in text, conditions): config/data/powers.yml
# list to be attached to new gear (name, types of gear): logic inside Power class and table
# on-gear link (name, level): GearPower, or stored as YAML in Gear
# on-character link: (name, level): stored as YAML in Character
# listing presented to user (name, specific effect in text): stored as YAML in Game
# to be processed in game (character, target list, effect in code, )
#   Power class (or module)
#   List of effects.Each effect
#     determine affected characters
#     each affected character
#       send effect to char

class Power
  include DataMapper::Resource
  
  property :name, String, :key => true
  property :source, Enum[:character, :gear, :location]
  property :effects, Yaml
  property :creation_frequency, Integer, :default => 1000
  
  # returns String with name of power
  def Power.random(options = {})
    options[:source] ||= :gear
    power_list = Power.all(options).to_ary
    return power_list.map{|x| x.name}.random(power_list.map{|x| x.creation_frequency})
  end

  def description
    
  end


end
