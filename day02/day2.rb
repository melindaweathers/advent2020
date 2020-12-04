def count_valid(filename)
  IO.readlines(filename)
    .map { |line| parse_line(line) }
    .select { |from, to, letter, password| valid_password?(from, to, letter, password) }
    .length
end

#1-3 a: abcde
def parse_line(line)
  from, to, letter, _, password = line.split(/[- \s:]/)
  [from.to_i, to.to_i, letter, password]
end

def valid_password?(from, to, letter, password)
  count = password.count(letter)
  from <= count && to >= count
end

puts count_valid('test.txt')
puts count_valid('input.txt')

def count_valid2(filename)
  IO.readlines(filename)
    .map { |line| parse_line(line) }
    .select { |from, to, letter, password| valid_password2?(from, to, letter, password) }
    .length
end

def valid_password2?(from, to, letter, password)
  (password[from-1] + password[to-1]).count(letter) == 1
end

puts count_valid2('test.txt')
puts count_valid2('input.txt')
