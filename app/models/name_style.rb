class NameStyle
  include DataMapper::Resource

  property :id, Serial
  has n, :name_patterns
  
end
