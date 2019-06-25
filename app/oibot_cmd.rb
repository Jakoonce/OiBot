require '_OiBot'

class OiBotCMD
  def initialize(input)
    @input = input
  end

  def execute
    OiBot.telegram(for: @input)
  end
end
