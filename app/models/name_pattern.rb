class NamePattern
  include DataMapper::Resource

  property :id, Serial
  belongs_to :name_style
  has n, :name_element_lists
  
  def initialize(word_template = [:start_cons, :vowels, :mid_cons, :vowels])
    word_template.each do |list_source|
      el = NameElementList.new(list_source)
      el.save
      self.name_element_lists << el
    end
  end
  
  def random(capitalized = true)
    result = ""
    self.name_element_lists.each do |el|
      result << el.random
    end
    if capitalized
      return result.capitalize
    else
      return result
    end
  end
  
end
