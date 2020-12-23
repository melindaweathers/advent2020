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
        if rule == '"a"' || rule == '"b"'
          @rules[num.to_i] = rule.gsub('"', '')
        else
          @rules[num.to_i] = rule
        end
      elsif line =~ /[ab]/
        @messages << line
      end
    end
    @regex = build_regex
    puts @regex
  end

  def build_regex
    Regexp.new('^' + build_regex_string(@rules[0], 0) + '$')
  end

  def build_regex_string(rule, rule_idx = 0)
    if ['a', 'b'].include?(rule)
      rule
    elsif rule_idx == 8 && @part2rules
      "(" + build_regex_string(@rules[42], 42) + ")+"
    elsif rule_idx == 11 && @part2rules
      @num += 1
      rule42 = build_regex_string(@rules[42], 42)
      rule31 = build_regex_string(@rules[31], 31)
      "(?<try#{@num}>#{rule42}\\g<try#{@num}>*#{rule31})+"
    else
      "(" + rule.split(' ').map{|part| part == '|' ? '|' : build_regex_string(@rules[part.to_i], part.to_i)}.join + ")"
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
