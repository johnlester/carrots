class Gear
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  belongs_to :character

  


end
