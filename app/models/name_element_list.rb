class NameElementList
  include DataMapper::Resource

  property :id, Serial
  property :order, Integer
  belongs_to :name_pattern
  has n, :name_weighted_elements
  is :list, :scope => [:name_pattern_id]

  STD_WEIGHTS = [0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 4, 5, 6, 7, 8, 10]
  SIMPLE_VOWELS = ['a', 'e', 'i', 'o', 'u']
  VOWELS = ['a', 'e', 'i', 'o', 'u', 'ee', 'ea', 'ai', 'ou', 'ar', 'el', 'er', 'oo']
  START_CONS = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'ph', 'qu', 
    'r', 's', 'sc', 'sl', 'sp', 'st', 'sw', 't', 'th', 'v', 'w', 'x', 'z']
  MID_CONS = ['b', 'bb', 'c', 'ck', 'd', 'dg', 'dd', 'f', 'ff', 'g', 'gg', 'h', 'j', 'k', 'l', 'll', 'm', 
    'mm', 'n', 'p', 'pp', 'ph', 'qu', 'r', 's', 'ss', 'sc', 't', 'tt', 'th', 'v', 'w', 'x', 'z']
  ENDINGS = ['or', 'el', 'us', 'e', 'aka', 'aj', 'o', 'ami', 'iki', 'emi', 'ani', 'i', 'a', 'ola', 'awa']
  
  def initialize(list_source = :vowels, weights = STD_WEIGHTS)
    if list_source.is_a? Symbol
      list_source = SIMPLE_VOWELS if list_source == :simple_vowels
      list_source = VOWELS if list_source == :vowels
      list_source = START_CONS if list_source == :start_cons
      list_source = MID_CONS if list_source == :mid_cons
      list_source = ENDINGS if list_source == :endings
    end
    
    list_source.each do |element|
      self.name_weighted_elements << NameWeightedElement.create(:text_element => element, :weight => weights.random)
    end
    
  end
  
  def random
    self.elements.random(self.weights)
  end
  
  def elements
    self.name_weighted_elements.collect {|n| n.text_element}
  end
  
  def weights
    self.name_weighted_elements.collect {|n| n.weight}
  end
  
end
