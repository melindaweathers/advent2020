# Shunting Yard Borrowed from https://en.wikipedia.org/wiki/Shunting-yard_algorithm
def elf_math(str, plus_precedence = false)
  op_stack = []
  output_queue = []
  str.split(/\s|(\()|(\))/).reject(&:empty?).each do |val|
    if val == '('
      op_stack.push(val)
    elsif ['+','*', ')'].include?(val)
      output_queue.push(output_queue.pop.send(op_stack.pop, output_queue.pop)) while op_stack.length > 0 && op_stack.last != '(' && !(op_stack.last == '*' && val == '+' && plus_precedence)
      if val == ')'
        op_stack.pop if op_stack.last == '('
      else
        op_stack.push(val)
      end
    else
      output_queue << val.to_i
    end
  end
  output_queue.push(output_queue.pop.send(op_stack.pop, output_queue.pop)) while op_stack.length > 0
  output_queue.pop
end

puts 'should be 71'
puts elf_math('1 + 2 * 3 + 4 * 5 + 6')

puts 'should be 51'
puts elf_math('1 + (2 * 3) + (4 * (5 + 6))')

puts 'should be 26'
puts elf_math('2 * 3 + (4 * 5)')

puts 'should be 437'
puts elf_math('5 + (8 * 3 + 9 + 3 * 4 * 3)')

puts 'should be 12240'
puts elf_math('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))')

puts 'should be 13632'
puts elf_math('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2')

puts IO.readlines('input.txt').map{|line| elf_math(line)}.sum


puts 'should be 231'
puts elf_math('1 + 2 * 3 + 4 * 5 + 6', true)

puts 'should be 51'
puts elf_math('1 + (2 * 3) + (4 * (5 + 6))', true)

puts 'should be 46'
puts elf_math('2 * 3 + (4 * 5)', true)

puts 'should be 1445'
puts elf_math('5 + (8 * 3 + 9 + 3 * 4 * 3)', true)

puts 'should be 669060'
puts elf_math('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))', true)

puts 'should be 23340'
puts elf_math('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', true)

puts IO.readlines('input.txt').map{|line| elf_math(line, true)}.sum
