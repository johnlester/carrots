class Agent
  include DataMapper::Resource
  
  property :id, Serial

  property :name, String
  property :health, Integer, :default => Proc.new { |r, p| rand(100) + rand(100) + 1}
  property :power, Integer, :default => Proc.new { |r, p| rand(100) + rand(100) + 1}
  property :as_of_time, Integer, :default => 0
  
  #baseline goal weights
  property :protect_self, Integer, :default => Proc.new { |r, p| rand(100) + 1}
  property :harm_enemy, Integer, :default => Proc.new { |r, p| rand(100) + 1}
  property :gain_power, Integer, :default => Proc.new { |r, p| rand(100) + 1}
  property :help_friend, Integer, :default => Proc.new { |r, p| rand(100) + 1}
  property :experience_pleasure, Integer, :default => Proc.new { |r, p| rand(100) + 1}
  
  has n, :possessions
  has n, :goals
  belongs_to :location

  def Agent.create_random
    new_agent = Agent.new

    #random name
    name_pattern = NamePattern.first || NamePattern.create([:start_cons, :simple_vowels, :mid_cons, :endings])
    new_agent.name = name_pattern.random    
    
    
    new_agent.save
    return new_agent
    
  end

  def add_goal(goal_type = [:protect_self, :harm_enemy, :gain_power, :help_friend, :experience_pleasure].random)
    
    case goal_type
    when :protect_self
      
    end
    
  end

  def move_to(location)
    self.location = location
  end

  def local_agents
    self.location.agents(:id.not => self.id)
  end

end
