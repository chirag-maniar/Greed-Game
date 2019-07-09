class DiceSet

  attr_reader :values
  def roll(num)
    
    @values = []
    i=0
    while i<num
      @values << rand(1..6)
      i += 1
    end
    @values
  end
end
