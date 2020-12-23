class SeaMonster
  attr_accessor :rules, :messages
  def initialize(filename, part2rules = false)
    @rules = {}
    @messages = []
    @part2rules = part2rules
    @num = 0
    IO.readlines(filename, chomp: true).each do |line|
      if line =~ /^\d+:/
        num, rule = line.split(': ')
        @rules[num.to_i] = rule.gsub('"', '')
      elsif line =~ /[ab]/
        @messages << line
      end
    end
    @regex = build_regex
    puts @regex
  end

  def build_regex
    Regexp.new('^' + build_regex_string(0) + '$')
  end

  def build_regex_string(rule_idx)
    rule = @rules[rule_idx]
    if ['a', 'b'].include?(rule)
      rule
    elsif rule_idx == 8 && @part2rules
      "(" + build_regex_string(42) + ")+"
    elsif rule_idx == 11 && @part2rules
      @num += 1
      "(?<try#{@num}>#{build_regex_string(42)}\\g<try#{@num}>*#{build_regex_string(31)})+"
    else
      "(" + rule.split(' ').map{|part| part == '|' ? '|' : build_regex_string(part.to_i)}.join + ")"
    end
  end

  def count_messages
    @messages.map{|message| @regex =~ message ? 1 : 0}.sum
  end
end

puts SeaMonster.new('sample.txt').count_messages
puts SeaMonster.new('input.txt').count_messages

puts SeaMonster.new('sample2.txt', true).count_messages
puts SeaMonster.new('input.txt', true).count_messages
