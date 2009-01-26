class Alliance
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String

  has n, :members, :class_name => "Agent"
  

end
