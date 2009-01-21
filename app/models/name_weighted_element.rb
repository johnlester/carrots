class NameWeightedElement
  include DataMapper::Resource

  property :id, Serial
  property :text_element,       String
  property :weight,             Integer
  belongs_to :name_element_list

end