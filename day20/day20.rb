class Tile
  attr_accessor :num, :orientations, :num_matches
  def initialize(lines)
    @num = lines[0][5..-2].to_i
    @orig = lines[1..-1].map{|line| line.chars}
    @orientations = find_orientations(@orig)
  end

  # original, left1, left2, left3, flip, flip+left1, flip+left2, flip+left3
  def find_orientations(orig)
    left1 = rotate_left(orig)
    left2 = rotate_left(left1)
    left3 = rotate_left(left2)
    flip = orig.reverse
    flipleft1 = rotate_left(flip)
    flipleft2 = rotate_left(flipleft1)
    flipleft3 = rotate_left(flipleft2)
    [orig, left1, left2, left3, flip, flipleft1, flipleft2, flipleft3]
  end

  def rotate_left(arr)
    arr.transpose.reverse
  end

  def num_matches(tiles)
    tiles.map{|tile| matches?(tile) ? 1 : 0}.sum
  end

  def matches?(other)
    return false if other.num == num
    other.orientations.any? do |orientation|
      @orig[0] == orientation[0] ||
        @orig[-1] == orientation[-1] ||
        @orig.map(&:first) == orientation.map(&:first) ||
        @orig.map(&:last) == orientation.map(&:last)
    end
  end
end

class Puzzle
  def initialize(filename)
    @tiles = {}
    IO.read(filename, chomp: true).split("\n\n").each do |chars|
      tile = Tile.new(chars.lines.map(&:chomp))
      @tiles[tile.num] = tile
    end
  end

  def find_corners
    @tiles.values.map { |tile| tile.num_matches(@tiles.values) == 2 ? tile.num : nil }.compact.inject(&:*)
  end
end

puts Puzzle.new('sample.txt').find_corners
puts Puzzle.new('input.txt').find_corners

