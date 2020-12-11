def find_weakness(filename, len)
  nums = IO.readlines(filename).map(&:to_i)
  prevs = []
  weakness = nil
  nums.each_with_index do |num, i|
    if i < len
      prevs << num
    elsif not_valid_num?(prevs, len, num)
      weakness = num
      break
    else
      prevs[i % len] = num
    end
  end
  weakness
end

def not_valid_num?(prevs, len, num)
  !prevs.combination(2).any?{|combo| combo.sum == num}
end

def find_contiguous(filename, invalid)
  nums = IO.readlines(filename).map(&:to_i)
  0.upto(nums.length - 1) do |i|
    end_of_range = find_end_of_range(nums, i, invalid)
    return nums[i..end_of_range].min + nums[i..end_of_range].max if end_of_range
  end
end

def find_end_of_range(nums, i, target)
  if nums[i] + nums[i+1] == target
    i+1
  elsif nums[i] + nums[i+1] < target
    find_end_of_range(nums, i+1, target - nums[i])
  end
end

puts find_weakness('test.txt', 5)
puts find_weakness('input.txt', 25)

puts find_contiguous('test.txt', 127)
puts find_contiguous('input.txt', 1504371145)
