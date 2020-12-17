require 'set'
Rule = Struct.new(:name, :from0, :to0, :from1, :to1) do
  def inside?(val)
    val.to_i.between?(from0, to0) || val.to_i.between?(from1, to1)
  end
end

class Tickets
  def initialize(rules_file, tickets_file)
    @parsed_rules = parse_rules(rules_file)
    @nearby_tickets = []
    IO.readlines(tickets_file, chomp: true).each_with_index do |line, i|
      if i == 0
        @my_ticket = line.split(',').map(&:to_i)
      else
        @nearby_tickets << line.split(',').map(&:to_i)
      end
    end
    @valid_tickets = @nearby_tickets.select{|ticket| valid_ticket?(ticket)}
  end

  def invalid_nearby_tickets
    @nearby_tickets.map do |ticket|
      ticket.map {|val| @parsed_rules.any?{|rule| rule.inside?(val)} ? 0 : val }.sum
    end.sum
  end

  def valid_ticket?(ticket)
    ticket.map {|val| @parsed_rules.any?{|rule| rule.inside?(val)} ? 0 : val }.sum == 0
  end

  def parse_rules(filename)
    IO.readlines(filename).map do |line|
      name, rest = line.split(': ')
      range0, _or, range1 = rest.split(' ')
      from0, to0 = range0.split('-')
      from1, to1 = range1.split('-')
      Rule.new(name, from0.to_i, to0.to_i, from1.to_i, to1.to_i)
    end
  end

  def find_possible_positions
    num_fields = @valid_tickets.first.length
    possibles = @parsed_rules.map{|rule| [rule.name, Set.new(0..num_fields - 1)]}.to_h
    @valid_tickets.each do |ticket|
      ticket.each_with_index do |val, i|
        @parsed_rules.each { |rule| possibles[rule.name].delete(i) unless rule.inside?(val) }
      end
    end
    possibles = find_definites(possibles)
    possibles.keys.select{|name| name.start_with?('departure')}.map{|name| @my_ticket[possibles[name].first]}.inject(&:*)
  end

  def find_definites(possibles)
    definites = Set.new()
    while possibles.values.any?{|vals| vals.length > 1} do
      possibles.each do |name, fields|
        if fields.length == 1
          definites.add(fields.first)
        else
          possibles[name] -= definites
        end
      end
    end
    possibles
  end
end

puts Tickets.new('sample_rules.txt', 'sample_tickets.txt').invalid_nearby_tickets
puts Tickets.new('rules.txt', 'tickets.txt').invalid_nearby_tickets

puts Tickets.new('rules.txt', 'tickets.txt').find_possible_positions
