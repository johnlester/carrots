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

  # Compiles list of possible actions, and calculates 
  # utility (desirability) of each one
  # Scale of final utility for actions
  # Assume 20 actions, with average utility of 10,000 = 200,000 typical total
  # Overwhelming (99%): 20,000,000
  # Very likely (95%): 4,000,000
  # Likely (60%): 300,000     
  def possible_actions
    # Interact with local agents
    local_agents.each do |local_agent|
      # Attack
        # Been attacked before by this agent?
          # Been attacked recently: 10,000,000
          # Been attacked in past: 100,000
          # Never been attacked: 100
        # How much like/dislike for this agent?
          # 
        # How much dislike/like for this agent's species?
        # Aggressiveness of self (personality trait, typical = 10): 1, 2, 5, 10, 50, 100, 1000, 10000
        
      
      
    end
    # Interact with local features
    
    # Interact with possessions

    # Attack nearby enemy
    # Build friendship/alliance
    # Defend self from attack
    # Give item/money/info to nearby agent
    # Trade item/money/info to nearby agent
    # Investigate local area
    # Build home/fort
    # Create item from resources
    # Gather local resources
    # Gain local followers (intimidation)
    # Tell followers what to do
  end

  def in_combat?
    if self.attacked_recently?
      if nearby?(last_attacker)
        return true
      # elsif nearby?(last_attacker's allies)
      end
    end
    return false
  end

end
