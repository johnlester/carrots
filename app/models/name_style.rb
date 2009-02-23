class NameStyle
  include DataMapper::Resource

  property :id, Serial
  
  property :vowels, Yaml
  property :cons, Yaml
  property :mid_only_cons, Yaml
  property :endings, Yaml
  property :ending_frequency, Float

  property :length_control, Integer
  
  COMMON_WEIGHTS = [1, 100, 200, 500, 800, 1000]
  UNCOMMON_WEIGHTS = [1, 1, 1, 10, 50, 100, 200]
  RARE_WEIGHTS = [1, 1, 1, 1, 1, 10, 100]
  
  COMMON_VOWELS = ['a', 'e', 'i']
  UNCOMMON_VOWELS = ['o', 'u', 'ee', 'ea', 'ai', 'ou', 'ar','er', 'oo']
  RARE_VOWELS = ['ae', 'el', 'y', 'ah', 'our', 'uo', 'eer']
  
  COMMON_CONS = ['c', 'd', 'f', 'g', 'l', 'm', 'n', 'p', 'r', 's', 't', 'th']
  UNCOMMON_CONS = ['b', 'h', 'j', 'k', 'st', 'v', 'w']
  RARE_CONS = ['ph', 'qu', 'sc', 'sl', 'sp', 'sw', 'x', 'z']
  MID_ONLY_CONS = ['bb', 'ck', 'dg', 'dd', 'ff', 'gg', 'll', 'ng', 'ss', 'tt', 'mm', 'pp']
  
  ENDINGS = [ ['aka', 'ake', 'aki', 'ana', 'a', 'e'],
              ['elle', 'alle', 'omme', 'igne', 'agne', 'isse', 'onne'],
              ['er', 'or', 'on', 'ot'],
              ['uela', 'ala', 'ado', 'asco', 'aso', 'os', 'arro', 'ua'],
              ['ev', 'iv', 'ov', 'oy'],
              ['esky', 'isky', 'osky', 'ensky', 'asky', 'enko', 'osko', 'onko', 'esko'],
              ['itz', 'etz', 'izz', 'ezz'],
              ['us', 'ius'],              
              ['ini', 'iti', 'izi', 'ia', 'a', 'ani', 'evi'],
              ['ar', 'evar', 'ivar'], 
              ['aar', 'aas', 'aan'],
              ['in', 'ou', 'o', 'u'],
              ['eh', 'ah', 'ih', 'aj'],
              ['a'],
              ['a', 'e', 'o', 'i'] ]
                
  
  def initialize(attributes = {})
    self.vowels = COMMON_VOWELS.randomly_weight(COMMON_WEIGHTS)
    self.vowels.update( UNCOMMON_VOWELS.randomly_weight(UNCOMMON_WEIGHTS) )
    self.vowels.update( RARE_VOWELS.randomly_weight(RARE_WEIGHTS) )

    self.cons = COMMON_CONS.randomly_weight(COMMON_WEIGHTS)
    self.cons.update( UNCOMMON_CONS.randomly_weight(UNCOMMON_WEIGHTS) )
    self.cons.update( RARE_CONS.randomly_weight(RARE_WEIGHTS) )
    self.mid_only_cons = MID_ONLY_CONS.randomly_weight(UNCOMMON_WEIGHTS)
    
    self.endings = ENDINGS.random
    self.ending_frequency = [0.6, 0.8, 0.9].random

    self.length_control = 1 + rand(4)
    
    self.save
  end  
  
  def mid_cons
    @mid_cons_cached ||= self.cons.merge(self.mid_only_cons)
  end 
      
  
  def random(capitalized = true)
    
    #Start of pattern
    if rand < 0.75
      pattern = [:cons, :vowels]
    else
      pattern = [:vowels]
    end

    #Loop zero or more times to build middle of pattern
    (rand(self.length_control)).times do
      case pattern[-1]
      when :vowels
        pattern << :mid_cons
        pattern << :mid_cons if rand < 0.25  
      when :mid_cons
        pattern << :vowels
      end
    end
    
    pattern << :mid_cons if pattern[-1] == :vowels
    
    pattern << :endings if rand < self.ending_frequency
    
    if pattern[-1] == :mid_cons and pattern[-2] == :mid_cons
      pattern.slice!(-1)
      pattern << :vowels
    end
          
    # Based on pattern generated above, draw letters
    result = ""
    pattern.each do |element|
      result << self.send(element).random
    end
    
    result.capitalize! if capitalized
    return result
  end
  
end
