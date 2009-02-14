class World
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :round, Integer, :default => 1 #time

  has n, :locations
  has n, :agents
  belongs_to :name_style

  def World.generate_world(options = {})
    options[:nodes] ||= 30
    options[:max_connections] ||= 5
    options[:name_style] ||= [:start_cons, :simple_vowels, :mid_cons, :endings]
    
    new_world = World.create
    
    #random name
    self.name_style = NameStyle.create(options[:name_style])
    new_world.name = self.name_style.random
  
    #generate locations
    
    
    #generate agents
  
  end

  def create_location_network(nodes, max_connections)
    # create locations
    nodes.times do |n|
      self.locations << Location.create(:name_style => self.name_style)
      self.save
      
    end
    
    self.save
  end

  def do_round
    
  end

end
