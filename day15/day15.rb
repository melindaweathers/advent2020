def nth_number(starting, target_idx)
  numbers = {}
  last = nil
  turn = 0
  starting.split(',').each_with_index do |n, i|
    numbers[n.to_i] = [i]
    last = n.to_i
    turn += 1
  end
  turn.upto(target_idx - 1) do |turn|
    next_num = numbers[last].length == 1 ? 0 : numbers[last][-1] - numbers[last][-2]
    numbers[next_num] ||= []
    numbers[next_num] << turn
    last = next_num
  end
  last
end

puts 'should be 436'
puts nth_number('0,3,6', 2020)

puts 'should be 1'
puts nth_number('1,3,2', 2020)

puts 'should be 10'
puts nth_number('2,1,3', 2020)

puts 'should be 27'
puts nth_number('1,2,3', 2020)

puts 'should be 78'
puts nth_number('2,3,1', 2020)

puts 'should be 438'
puts nth_number('3,2,1', 2020)

puts 'should be 1836'
puts nth_number('3,1,2', 2020)

puts 'first star'
puts nth_number('2,0,6,12,1,3', 2020)


puts 'should be 175594'
puts nth_number('0,3,6', 30000000)

#puts 'should be 2578'
#puts nth_number('1,3,2', 30000000)

#puts 'should be 3544142'
#puts nth_number('2,1,3', 30000000)

#puts 'should be 261214'
#puts nth_number('1,2,3', 30000000)

#puts 'should be 6895259'
#puts nth_number('2,3,1', 30000000)

#puts 'should be 18'
#puts nth_number('3,2,1', 30000000)

#puts 'should be 362'
#puts nth_number('3,1,2', 30000000)

puts 'second star'
puts nth_number('2,0,6,12,1,3', 30000000)

