class NameStyle
  include DataMapper::Resource

  property :id, Serial
  
  property :vowels, Yaml
  property :start_cons, Yaml
  property :mid_cons, Yaml
  property :endings, Yaml

  property :max_length, Integer
  
  STD_WEIGHTS = [0, 0, 0, 0, 1, 1, 2, 2, 5, 10]
  VOWELS = ['a', 'e', 'a', 'e', 'i', 'o', 'a', 'e', 'i', 'o', 'u', 'ee', 'ea', 'ai', 'ou', 'ar', 'el', 'er', 'oo', 'y', 'ah']
  START_CONS = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'l', 'm', 'm', 'n', 'p', 'ph', 'qu', 
    'r', 's', 's', 'sc', 'sl', 'sp', 'st', 'sw', 't', 't', 'th', 'th', 'v', 'w', 'x', 'z']
  MID_CONS = ['b', 'bb', 'c', 'ck', 'd', 'dg', 'dd', 'f', 'ff', 'g', 'gg', 'h', 'j', 'k', 'l', 'll', 'm', 'm', 
    'mm', 'n', 'n', 'p', 'pp', 'ph', 'qu', 'r', 's', 's', 'ss', 'sc', 't', 't', 'tt', 'th', 'v', 'w', 'x', 'z']
  ENDINGS = ['or', 'el', 'us', 'e', 'aka', 'aj', 'o', 'ami', 'iki', 'emi', 'ani', 'i', 'a', 'ola', 'awa']
  
  
  def initialize
    self.vowels = VOWELS.randomly_weight(STD_WEIGHTS)
    self.start_cons = START_CONS.randomly_weight(STD_WEIGHTS)
    self.mid_cons = MID_CONS.randomly_weight(STD_WEIGHTS)
    self.endings = ENDINGS.randomly_weight(STD_WEIGHTS)
    self.max_length = 3 + rand(4)
    self.save
  end  
    
  def random(capitalized = true)
    case (2 + rand(self.max_length - 1))
    when 2
      pattern = [ [:vowels, :mid_cons],
                  [:start_cons, :vowels],
                  [:start_cons, :endings] ].random
    when 3
      pattern = [ [:vowels, :mid_cons, :vowels],
                  [:start_cons, :vowels, :mid_cons],
                  [:start_cons, :vowels, :endings] ].random
    when 4
      pattern = [ [:vowels, :mid_cons, :vowels, :mid_cons],
                  [:vowels, :mid_cons, :vowels, :endings],
                  [:start_cons, :vowels, :mid_cons, :endings],
                  [:start_cons, :vowels, :mid_cons, :vowels] ].random
    when 5
      pattern = [ [:vowels, :mid_cons, :vowels, :mid_cons, :vowels],
                  [:vowels, :mid_cons, :vowels, :mid_cons, :endings],
                  [:start_cons, :vowels, :mid_cons, :vowels, :mid_cons] ].random
    when 6
      pattern = [ [:vowels, :mid_cons, :vowels, :mid_cons, :vowels, :mid_cons],
                  [:vowels, :mid_cons, :vowels, :mid_cons, :vowels, :endings],
                  [:start_cons, :vowels, :mid_cons, :vowels, :mid_cons, :endings],
                  [:start_cons, :vowels, :mid_cons, :vowels, :mid_cons, :vowels] ].random
    end
    
    result = ""
    pattern.each do |element|
      result << self.send(element).random
    end
    
    result.capitalize! if capitalized
    return result
  end
  
end
