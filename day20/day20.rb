require 'set'
class Tile
  attr_accessor :num, :orientations, :final_orientation
  def initialize(lines)
    @num = lines[0][5..-2].to_i
    @orig = lines[1..-1].map{|line| line.chars}
    @orientations = Tile.find_orientations(@orig)
    @final_orientation = nil
  end

  # original, left1, left2, left3, flip, flip+left1, flip+left2, flip+left3
  def self.find_orientations(orig)
    left1 = rotate_left(orig)
    left2 = rotate_left(left1)
    left3 = rotate_left(left2)
    flip = orig.reverse
    flipleft1 = rotate_left(flip)
    flipleft2 = rotate_left(flipleft1)
    flipleft3 = rotate_left(flipleft2)
    [orig, left1, left2, left3, flip, flipleft1, flipleft2, flipleft3]
  end

  # Use correct orientation and strip borders
  def to_piece
    @orientations[@final_orientation][1..-2].map do |row|
      row[1..-2]
    end
  end

  def self.rotate_left(arr)
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
  FINAL_TILE_SIZE = 8
  def initialize(filename)
    @tiles = []
    IO.read(filename, chomp: true).split("\n\n").each do |chars|
      @tiles << Tile.new(chars.lines.map(&:chomp))
    end
    @grid_size = Math.sqrt(@tiles.length).to_i
    @corners = find_corners
    @edges = find_edges
    @used_pieces = Set.new
    @final_grid = []
    build_grid
  end

  def corners_product
    @corners.map(&:num).inject(&:*)
  end

  def find_corners
    @tiles.map { |tile| tile.num_matches(@tiles) == 2 ? tile : nil }.compact
  end

  def find_edges
    @tiles.map { |tile| tile.num_matches(@tiles) == 3 ? tile : nil }.compact
  end

  def place_next_tile(prev_tile, direction, row, col)
    @tiles.each do |edge|
      next if @used_pieces.include?(edge.num)
      new_orientation = prev_tile.matches_side?(prev_tile.final_orientation, edge, direction)
      if new_orientation
        edge.final_orientation = new_orientation
        @grid[row][col] = edge
        @used_pieces << edge.num
        break
      end
    end
  end

  def build_grid
    @grid = Array.new(@grid_size) { Array.new(@grid_size) }
    first_corner = @corners.first
    first_corner.final_orientation = first_corner.first_corner_orientation(@edges)
    @used_pieces << first_corner.num
    @grid[0][0] = first_corner

    # Build first row
    1.upto(@grid_size - 1) do |col|
      place_next_tile(@grid[0][col-1], :e, 0, col)
    end

    # Build other rows
    1.upto(@grid_size - 1) do |row|
      0.upto(@grid_size - 1) do |col|
        place_next_tile(@grid[row-1][col], :s, row, col)
      end
    end

    # Build the final grid with all the tiles
    @grid.each do |row|
      0.upto(FINAL_TILE_SIZE - 1) do |line|
        final_row = []
        row.each { |tile| final_row += tile.to_piece[line] }
        @final_grid << final_row
      end
    end
    #puts @final_grid.map{|row| puts row.join(' ')}
  end

  def build_monster(final_grid_size)
    row1 = '                  # '
    row2 = '#    ##    ##    ###'
    row3 = ' #  #  #  #  #  #   '
    space = ' '*(final_grid_size - 20)
    "#{row1}#{space}#{row2}#{space}#{row3}".chars.map{|c| c == '#' ? '1' : '0'}.join.to_i(2)
  end

  def find_monsters(grid_orientation)
    line = grid_orientation.flatten.map{|char| char == '#' ? '1' : '0'}.join.to_i(2)
    monster_count = 0
    monster = build_monster(grid_orientation.length)
    (grid_orientation.length**2).times do
      if (line & monster) == monster
        monster_count += 1
        line = (line ^ monster)
      end
      monster = monster << 1
    end
    [monster_count, line.to_s(2).count("1")]
  end

  def find_monsters_and_orientation
    Tile.find_orientations(@final_grid).each do |orientation|
      monster_count, roughness = find_monsters(orientation)
      return roughness if monster_count > 0
    end
  end
end

puts Puzzle.new('sample.txt').corners_product
puts Puzzle.new('input.txt').corners_product

puts Puzzle.new('sample.txt').find_monsters_and_orientation
puts Puzzle.new('input.txt').find_monsters_and_orientation
