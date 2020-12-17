class Cubes4D
  attr_accessor :space
  CHANGES = [0,1,-1].repeated_permutation(4).to_a - [[0,0,0,0]]
  def initialize(filename)
    @space = {}
    IO.readlines(filename, chomp: true).each_with_index do |line, y|
      line.chars.each_with_index {|char, x| @space["#{x} #{y} 0 0"] = char}
    end
  end

  def run_cycle
    new_space = {}
    @space.keys.flat_map{|key| [key] + neighboring_coords(key)}.uniq.each do |key|
      neighs = num_active_neighbors(key)
      if @space[key] == '#'
        new_space[key] = ([2,3].include?(neighs) ? '#' : '.')
      else
        new_space[key] = '#' if 3 == neighs
      end
    end
    @space = new_space
    #puts "Active keys: #{@space.select{|k, v| v == '#'}}"
  end

  def num_active_neighbors(key)
    neighboring_coords(key).map { |coords| @space[coords] == '#' ? 1 : 0 }.sum
  end

  def neighboring_coords(key)
    x, y, z, w = key.split(' ').map(&:to_i)
    CHANGES.map do |dx, dy, dz, dw|
      "#{x + dx} #{y + dy} #{z + dz} #{w + dw}"
    end
  end

  def boot
    6.times { run_cycle }
    @space.values.count('#')
  end
end

puts Cubes4D.new('sample.txt').boot
puts Cubes4D.new('input.txt').boot


