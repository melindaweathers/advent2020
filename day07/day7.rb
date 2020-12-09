Content = Struct.new(:count, :color)

class LuggageRules
  def initialize(filename)
    @rules = {}
    IO.readlines(filename).each do |line|
      key, vals = parse_line(line)
      @rules[key] = vals
    end
  end

  def parse_line(line)
    container, contents = line.gsub('bags', '').split(' contain ')
    key = container.strip
    vals = contents.split(',').map do |bag_type|
      words = bag_type.split(' ')
      unless words[0] == 'no'
        color = words[1].strip + ' ' + words[2].strip
        Content.new(words[0].to_i, color)
      end
    end.compact
    [key, vals]
  end

  def inspect
    @rules.inspect
  end

  def find_containers(color)
    containers = []
    @rules.each do |key, vals|
      if vals.any?{|f| f.color == color}
        containers << key
        containers += find_containers(key)
      end
    end
    containers.uniq
  end

  def count_contained(color)
    return 0 unless @rules[color]
    @rules[color].map do |content|
      content.count * ( 1 + count_contained(content.color))
    end.sum
  end
end

puts LuggageRules.new('test.txt').find_containers('shiny gold').length
puts LuggageRules.new('input.txt').find_containers('shiny gold').length

puts LuggageRules.new('test.txt').count_contained('shiny gold')
puts LuggageRules.new('input.txt').count_contained('shiny gold')
