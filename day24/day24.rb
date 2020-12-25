class Lobby
  DIRS = {e: [1,-1,0], se: [0,-1,1], sw: [-1,0,1], w: [-1,1,0], nw: [0,1,-1], ne: [1,0,-1]}
  WHITE = false
  BLACK = true

  def initialize(filename)
    @tiles = Hash.new(WHITE)
    IO.readlines(filename, chomp: true).each do |line|
      prev = nil
      coords = [0,0,0]
      line.chars.each do |char|
        if ['n','s'].include?(char)
          prev = char
          next
        elsif prev
          dir = prev + char
          prev = nil
        else
          dir = char
        end
        coords = coords.zip(DIRS[dir.to_sym]).map(&:sum)
      end
      @tiles[coords] = !@tiles[coords]
    end
  end

  def run_cycle
    new_space = {}
    @tiles.keys.flat_map{|key| [key] + neighboring_coords(key)}.uniq.each do |key|
      neighs = num_active_neighbors(key)
      if @tiles[key] == BLACK
        new_space[key] = (neighs == 0 || neighs > 2) ? WHITE : BLACK
      else
        new_space[key] = neighs == 2 ? BLACK : WHITE
      end
    end
    @tiles = new_space
  end

  def num_active_neighbors(key)
    neighboring_coords(key).map { |coords| @tiles[coords] == BLACK ? 1 : 0 }.sum
  end

  def neighboring_coords(key)
    DIRS.values.map { |diffs| diffs.zip(key).map(&:sum) }
  end

  def count_black_tiles
    @tiles.map{|k, v| v == BLACK ? 1 : 0}.sum
  end

  def run_days(num)
    num.times { run_cycle }
    count_black_tiles
  end
end

puts Lobby.new('sample.txt').count_black_tiles
puts Lobby.new('input.txt').count_black_tiles

puts Lobby.new('sample.txt').run_days(100)
puts Lobby.new('input.txt').run_days(100)
