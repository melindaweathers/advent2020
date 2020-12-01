def find_2020(filename)
  nums = IO.readlines(filename).map(&:to_i)
  len = nums.length
  nums.each_with_index do |num, i|
    (i+1).upto(len-1) do |j|
      other = nums[j]
      puts "#{num}, #{other}: #{num*other}" if num + other == 2020
    end
  end
end

find_2020('test_input.txt')
find_2020('input.txt')

def find_three_2020(filename)
  nums = IO.readlines(filename).map(&:to_i)
  a = nums.combination(3).find { |a| a.sum == 2020 }
  puts "#{a.inspect}: #{a.inject(1, :*)}"
end

find_three_2020('test_input.txt')
find_three_2020('input.txt')

