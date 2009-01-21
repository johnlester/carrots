class Array
  def random(weights=nil)
    return random(map {|n| n.send(weights)}) if weights.is_a? Symbol
    
    weights ||= Array.new(length, 1.0)
    total = weights.inject(0.0) {|t,w| t+w}
    point = rand * total
    
    zip(weights).each do |n,w|
      return n if w >= point
      point -= w
    end
  end
  
  def combination(num)
    return [] if num < 1 || num > size
    return map{|e| [e] } if num == 1
    tmp = self.dup
    self[0, size - (num - 1)].inject([]) do |ret, e|
      tmp.shift
      ret += tmp.combination(num - 1).map{|a| a.unshift(e) }
    end
  end

end

class Hash
  def random
    self.keys.random(self.values)
  end
end

class WeightedWalk
  attr_accessor :start, :current

  def initialize(start = {:a => 1, :b => 1})
    @start = start
    @current = @start.dup
  end

  def walk(n = 1)
    n.times do
      @current[@current.random] += 1
    end
  end
  
end

