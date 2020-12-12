def find_chain(filename)
  joltages = IO.readlines(filename).map(&:to_i).sort
  ones = 0
  threes = 1
  last = 0
  joltages.each do |jolts|
    if jolts - last == 1
      ones += 1
    elsif jolts - last == 3
      threes += 1
    end
    last = jolts
  end
  ones * threes
end

puts find_chain('test.txt')
puts find_chain('input.txt')

class Adapters
  attr_accessor :joltages

  #[1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]
  def initialize(filename)
    @joltages = IO.readlines(filename).map(&:to_i).sort
    @counts = {}
  end

  def count_arrangements
    count_remaining_arrangements(-1)
  end

  def count_remaining_arrangements(prev_idx)
    return @counts[prev_idx] if @counts[prev_idx]
    options = next_adapters(prev_idx)
    res = if options.length > 0
      options.map do |i|
        count_remaining_arrangements(i)
      end.sum
    else
      1
    end
    @counts[prev_idx] = res
    res
  end

  def next_adapters(i)
    idxs = []
    prev = i < 0 ? 0 : joltages[i]
    idxs << i + 1 if joltages[i + 1]
    idxs << i + 2 if joltages[i + 2] && joltages[i + 2] - 3 <= prev
    idxs << i + 3 if joltages[i + 3] && joltages[i + 3] - 3 <= prev
    idxs
  end
end

puts Adapters.new('small.txt').count_arrangements
puts Adapters.new('test.txt').count_arrangements
puts Adapters.new('input.txt').count_arrangements

