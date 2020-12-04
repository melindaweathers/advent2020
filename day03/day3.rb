class Grid
  def initialize(filename)
    @grid = IO.readlines(filename, chomp: true)
    @lenx = @grid.first.length
    @leny = @grid.length
    @posx = 0
    @posy = 0
  end

  def move(right, down)
    @posx = (@posx + right) % @lenx
    @posy = @posy + down
    if @posy >= @leny
      :done
    else
      @grid[@posy][@posx] == '#' ? 1 : 0
    end
  end

  def move_all(right, down)
    total = 0
    loop do
      result = move(right, down)
      break if result == :done
      total += result
    end
    total
  end

  def try_all_slopes
    slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
    product = 1

    slopes.each do |right, down|
      @posx = 0
      @posy = 0
      product *= move_all(right, down)
    end
    product
  end
end

puts Grid.new('test.txt').move_all(3,1)
puts Grid.new('input.txt').move_all(3,1)

puts Grid.new('test.txt').try_all_slopes
puts Grid.new('input.txt').try_all_slopes

