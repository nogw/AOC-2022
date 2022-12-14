class CPU
  def initialize(filename)
    @filename = filename
    @value = 1
    @cycle = 0
    @record = {}
    @screen = []
  end

  def execute
    input = File.read(@filename).split("\n")
    input.each { |cmd| public_send(*cmd.split(' ')) }
    crt    
  end

  def noop(_arg = nil)
    draw_pixel
    @cycle += 1
    record_cycle
  end

  def addx(value)
    noop
    noop
    @value += value.to_i
  end
  
  def crt
    @screen.each_slice(40).map(&:join)
  end

  def record_cycle
    return unless recordable?
    @record[@cycle] = @value
  end

  def recordable?
    @cycle == 20 || (@cycle - 20) % 40 == 0
  end

  def draw_pixel
    pixel = (@value-1..@value+1).include?(@cycle % 40) ? '#' : '.'
    @screen << pixel
  end
end

puts CPU.new('input.txt').execute