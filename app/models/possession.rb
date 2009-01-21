class Possession
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :amount, Integer

  belongs_to :agent
  
end
