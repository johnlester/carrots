class Gear
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :gear_type, Enum[:weapon, :armor, :clothes, :jewelry, :shoes, :gloves, :bauble]
  property :marks, Flag[:leaf, :mountain, :sun, :moon, :circle, :stars, :triangle] #may want to rethink using Flags for this
  
  belongs_to :character

  def initialize
    
  end

  def create_random(options = {})
  
  end

end
