class Location
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  belongs_to :world
  has n, :neighbors, :through => Resource, :class_name => 'Location'
  has n, :agents

  def initialize(options = {})
    options[:name_pattern] ||= NamePattern.create([:start_cons, :simple_vowels, :mid_cons, :endings])
    self.name = options[:name_pattern].random
  end

  def make_neighbors_with(location)
    self.neighbors << location
    location.neighbors << self
    self.save
    location.save
  end


end
