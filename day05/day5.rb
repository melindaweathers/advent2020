class Seat
  attr_accessor :enc, :row, :col
  def initialize(enc)
    @enc = enc
    @row = find_row
    @col = find_col
  end

  def seat_id
    @row * 8 + col
  end

  private

  def find_row
    find_pos(0, 127, enc[0..6])
  end

  def find_col
    find_pos(0, 7, enc[7..9])
  end

  def find_pos(min, max, str)
    str.each_char do |char|
      min, max = update_range(min, max, char)
    end
    min
  end

  def update_range(min, max, char)
    if %w[F L].include?(char)
      [min, (max-min)/2 + min]
    else
      [(max-min)/2 + min + 1, max]
    end
  end
end

puts 'should be 357'
puts Seat.new('FBFBBFFRLR').seat_id

puts 'should be 567'
puts Seat.new('BFFFBBFRRR').seat_id

puts 'should be 119'
puts Seat.new('FFFBBBFRRR').seat_id

puts 'should be 820'
puts Seat.new('BBFFBBFRLL').seat_id

puts 'max in file'
seat_ids = IO.readlines('input.txt').map { |line| Seat.new(line).seat_id }
puts seat_ids.max

puts 'missing seat'
last_seat = 0
seat_ids.sort.each do |id|
  puts id - 1 if id > last_seat + 1
  last_seat = id
end
