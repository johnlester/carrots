class Location
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  has n, :neighbors, :through => Resource, :class_name => 'Location'
  has n, :agents

  def make_neighbors_with(location)
    self.neighbors << location
    location.neighbors << self
    self.save
    location.save
  end

end
