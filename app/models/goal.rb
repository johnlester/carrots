class Goal
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :goal_type, Enum[:protect_self, :harm_enemy, :gain_power, :help_friend, :experience_pleasure]
  property :strength, Integer

  belongs_to :agent
  
  # def Goal.create_random
  #   new_goal = Goal.new
  #   
  #   new_goal.goal_type = [:protect_self, :harm_enemy, :gain_power, :help_friend, :experience_pleasure].random
  #   
  #   case new_goal.goal_type
  #   when :protect_self
  #     
  #   end
  #   
  #   
  #   return new_goal
  # end
  

end
