class Ferry
  DIRS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  def initialize(filename, version = 1)
    @layout = IO.readlines(filename, chomp: true).map{|line| line.chars}
    @version = version
    @occupied_limit = version == 1 ? 4 : 5
    @num_rows = @layout.length
    @num_cols = @layout[0].length
  end

  def run_until_no_change
    loop { break unless run_round }
    @layout.map{|row| row.count('#')}.sum
  end

  def run_round
    changes = false
    @layout = @layout.map.with_index do |row, row_idx|
      row.map.with_index do |seat, col_idx|
        if seat == '.'
          '.'
        else
          new_seat = new_state(seat, row_idx, col_idx)
          changes = true if new_seat != seat
          new_seat
        end
      end
    end
    changes
  end

  def new_state(seat, row_idx, col_idx)
    occ = count_occupied(seat, row_idx, col_idx)
    if seat == 'L' && occ == 0
      '#'
    elsif seat == '#' && occ >= @occupied_limit
      'L'
    else
      seat
    end
  end

  def count_occupied(seat, row_idx, col_idx)
    @version == 1 ? count_occupied1(seat, row_idx, col_idx) : count_occupied2(seat, row_idx, col_idx)
  end

  private

  def count_occupied1(seat, row_idx, col_idx)
    min_row = [row_idx - 1, 0].max
    max_row = [row_idx + 1, @num_rows - 1].min
    min_col = [col_idx - 1, 0].max
    max_col = [col_idx + 1, @num_cols - 1].min
    count = @layout[min_row .. max_row].flat_map{|row| row[min_col .. max_col]}.count('#')
    seat == '#' ? count - 1 : count
  end

  def count_occupied2(_seat, row_idx, col_idx)
    DIRS.map do |ver, hor|
      occupied_in_direction?(row_idx, col_idx, ver, hor) ? 1 : 0
    end.sum
  end

  def occupied_in_direction?(row_idx, col_idx, ver, hor)
    next_row = row_idx + ver
    next_col = col_idx + hor
    if !next_row.between?(0, @num_rows - 1) || !next_col.between?(0, @num_cols - 1)
      false
    elsif @layout[next_row][next_col] == '#'
      true
    elsif @layout[next_row][next_col] == 'L'
      false
    else
      occupied_in_direction?(next_row, next_col, ver, hor)
    end
  end
end


puts Ferry.new('test.txt').run_until_no_change
puts Ferry.new('input.txt').run_until_no_change

puts Ferry.new('test.txt', 2).run_until_no_change
puts Ferry.new('input.txt', 2).run_until_no_change
