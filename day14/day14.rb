class DockingProgram
  def initialize(filename)
    @filename = filename
    @mask = 0
    @mem = {}
  end

  def run_program
    IO.readlines(@filename).each do |line|
      target, val = line.split(' = ')
      if target == 'mask'
        @ones_mask = val.gsub('X','0').to_i(2)
        @zeros_mask = val.gsub('X','1').to_i(2)
      else
        digit = target[4..-2].to_i
        @mem[digit] = (@ones_mask | val.to_i) & @zeros_mask
      end
    end
    @mem.values.sum
  end

  def run_program2
    IO.readlines(@filename).each do |line|
      target, val = line.split(' = ')
      if target == 'mask'
        @ones_mask = val.gsub('X','0').to_i(2)
        @orig_mask = val
      else
        digit = target[4..-2].to_i
        with_xes = replace_with_xes((@ones_mask | digit.to_i), @orig_mask)
        expand_addresses(with_xes).each{|address| @mem[address.to_i(2)] = val.to_i}
      end
    end
    @mem.values.sum
  end

  def replace_with_xes(val, mask)
    valstr = val.to_s(2).rjust(mask.length - 1, '0')
    mask.each_char.with_index { |char, i| valstr[i] = 'X' if char == 'X'}
    valstr
  end

  def expand_addresses(val)
    if val.index('X')
      expand_addresses(val.sub('X', '0')) + expand_addresses(val.sub('X', '1'))
    else
      [val]
    end
  end
end

puts DockingProgram.new('sample.txt').run_program
puts DockingProgram.new('input.txt').run_program

puts DockingProgram.new('sample2.txt').run_program2
puts DockingProgram.new('input.txt').run_program2
