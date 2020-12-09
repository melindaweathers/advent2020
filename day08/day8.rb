class Machine
  attr_accessor :instructions, :terminated, :acc
  def initialize(filename)
    @filename = filename
    reset
  end

  def reset
    @acc = 0
    @curr = 0
    @terminated = false
    @instructions = IO.readlines(@filename)
  end

  def flip_instruction(ctr)
    if @instructions[ctr].start_with?('jmp')
      @instructions[ctr].gsub!(/jmp/, 'nop')
    elsif @instructions[ctr].start_with?('nop')
      @instructions[ctr].gsub!(/nop/, 'jmp')
    end
  end

  def run_next
    line = @instructions[@curr]
    if line
      instruction, arg = line.split(' ')
      send("run_#{instruction}", arg)
    else
      @terminated = true
    end
  end

  def run_nop(_arg)
    @curr += 1
  end

  def run_acc(arg)
    @acc += arg.to_i
    @curr += 1
  end

  def run_jmp(arg)
    @curr += arg.to_i
  end

  def run_until_loop
    run_so_far = []
    loop do
      break if run_so_far.include?(@curr)
      run_so_far << @curr
      run_next
    end
    @acc
  end
end

def find_non_looping(filename)
  machine = Machine.new(filename)
  num_lines = machine.instructions.length
  0.upto(num_lines - 1) do |num|
    machine.reset
    machine.flip_instruction(num)
    outcome, acc = machine.run_until_loop
    break if machine.terminated
  end
  machine.acc
end


puts Machine.new('test.txt').run_until_loop
puts Machine.new('input.txt').run_until_loop

puts find_non_looping('test.txt')
puts find_non_looping('input.txt')
