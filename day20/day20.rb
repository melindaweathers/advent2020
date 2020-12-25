require 'set'
class Tile
  DIRECTIONS = [:n, :e, :s, :w]
  attr_accessor :num, :orientations, :num_matches, :final_orientation
  def initialize(lines)
    @num = lines[0][5..-2].to_i
    @orig = lines[1..-1].map{|line| line.chars}
    @orientations = find_orientations(@orig)
    @final_orientation = nil
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

  def at_final_orientation
    @orientations[@final_orientation]
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

  def matches_side?(my_orientation, other_tile, dir)
    me = @orientations[my_orientation]
    other_tile.orientations.each_with_index do |orientation, idx|
      matches = case dir
      when :s
        me.last == orientation.first
      when :n
        me.first == orientation.last
      when :w
        me.map(&:first) == orientation.map(&:last)
      when :e
        me.map(&:last) == orientation.map(&:first)
      end
      return idx if matches
    end
    false
  end

  def first_corner_orientation(edges)
    one_edge, two_edge = edges.select{|edge| matches?(edge)}
    # Next edge should match to my right
    orientations.each_with_index do |me, idx|
      return idx if matches_side?(idx, one_edge, :e) && matches_side?(idx, two_edge, :s)
    end
  end
end

class Puzzle
  def initialize(filename)
    @tiles = []
    IO.read(filename, chomp: true).split("\n\n").each do |chars|
      @tiles << Tile.new(chars.lines.map(&:chomp))
    end
    @grid_size = Math.sqrt(@tiles.length).to_i
    @corners = find_corners
    @edges = find_edges
  end

  def find_corners
    @tiles.map { |tile| tile.num_matches(@tiles) == 2 ? tile : nil }.compact
  end

  def find_edges
    @tiles.map { |tile| tile.num_matches(@tiles) == 3 ? tile : nil }.compact
  end

  def build_grid
    @grid = Array.new(@grid_size) { Array.new(@grid_size) }
    @used_pieces = Set.new
    first_corner = @corners.first
    first_corner.final_orientation = first_corner.first_corner_orientation(@edges)
    @used_pieces << first_corner.num
    @grid[0][0] = first_corner
    row = 0
    # Build first row
    1.upto(@grid_size - 1) do |col|
      prev_tile = @grid[row][col-1]
      @tiles.each do |edge|
        next if @used_pieces.include?(edge.num)
        new_orientation = prev_tile.matches_side?(prev_tile.final_orientation, edge, :e)
        if new_orientation
          edge.final_orientation = new_orientation
          @grid[row][col] = edge
          @used_pieces << edge.num
          break
        end
      end
    end
    # Build other rows
    1.upto(@grid_size - 1) do |row|
      0.upto(@grid_size - 1) do |col|
        prev_tile = @grid[row-1][col]
        @tiles.each do |edge|
          next if @used_pieces.include?(edge.num)
          new_orientation = prev_tile.matches_side?(prev_tile.final_orientation, edge, :s)
          if new_orientation
            edge.final_orientation = new_orientation
            @grid[row][col] = edge
            @used_pieces << edge.num
            break
          end
        end
      end
    end
    @grid.each{|row| puts row.map{|t| "#{t.num}: #{t.final_orientation}" if t}.join(' ')}
  end


end

#puts Puzzle.new('sample.txt').find_corners.inject(&:*)
#puts Puzzle.new('input.txt').find_corners.inject(&:*)

Puzzle.new('sample.txt').build_grid
