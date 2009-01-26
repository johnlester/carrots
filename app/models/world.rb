class World
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :round, Integer, :default => 1 #time

  has n, :locations
  has n, :agents
  belongs_to :name_pattern

  def World.generate_world(options = {})
    options[:nodes] ||= 30
    options[:max_connections] ||= 5
    options[:name_pattern] ||= [:start_cons, :simple_vowels, :mid_cons, :endings]
    
    new_world = World.create
    
    #random name
    self.name_pattern = NamePattern.create(options[:name_pattern])
    new_world.name = self.name_pattern.random
  
    #generate locations
    
    
    #generate agents
  
  end

  def create_location_network(nodes, max_connections)
    # create locations
    nodes.times do |n|
      self.locations << Location.create(:name_pattern => self.name_pattern)
      self.save
      
    end
    
    self.save
  end

  def do_round
    
  end

end
