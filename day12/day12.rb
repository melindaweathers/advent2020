class Ship
  DIRECTIONS = {E: [0, 1, 0], S: [1, 0, 90], W: [0, -1, 180], N: [-1, 0, 270]}
  DIRECTION_ANGLES = {0 => :E, 90 => :S, 180 => :W, 270 => :N}

  def initialize(filename)
    @row = 0
    @col = 0
    @direction = :E
    @instructions = IO.readlines(filename).map{|line| [line[0].to_sym, line[1..-1].to_i]}
  end

  def distance
    @row.abs + @col.abs
  end

  def move_all
    @instructions.each do |action, distance|
      move(action, distance)
    end
    self
  end

  def move(action, distance)
    if DIRECTIONS.keys.include?(action)
      @row += DIRECTIONS[action][0]*distance
      @col += DIRECTIONS[action][1]*distance
    elsif action == :F
      @row += DIRECTIONS[@direction][0]*distance
      @col += DIRECTIONS[@direction][1]*distance
    elsif action == :L
      rotate_angle(-1*distance)
    elsif action == :R
      rotate_angle(distance)
    else
      raise "Invalid move #{action} #{distance}"
    end
    #puts "#{@row}, #{@col}, #{@direction}"
  end

  def rotate_angle(angle)
    current_angle = DIRECTIONS[@direction][2]
    current_angle = ((current_angle + angle) % 360)
    @direction = DIRECTION_ANGLES[current_angle]
  end
end

puts Ship.new('test.txt').move_all.distance
puts Ship.new('input.txt').move_all.distance

class ShipWithWaypoint < Ship
  def initialize(filename)
    super
    @wayrow = -1
    @waycol = 10
  end

  def move(action, distance)
    if action == :F
      @row += @wayrow*distance
      @col += @waycol*distance
    elsif DIRECTIONS.keys.include?(action)
      @wayrow += DIRECTIONS[action][0]*distance
      @waycol += DIRECTIONS[action][1]*distance
    elsif action == :L
      rotate_left(distance)
    elsif action == :R
      rotate_right(distance)
    else
      raise "Invalid move #{action} #{distance}"
    end
    #puts "#{@row}, #{@col}, #{@direction}"
  end

  def rotate_right(angle)
    return if angle == 0
    @wayrow, @waycol = [@waycol, -1*@wayrow]
    rotate_right(angle - 90)
  end

  def rotate_left(angle)
    return if angle == 0
    @wayrow, @waycol = [-1*@waycol, @wayrow]
    rotate_left(angle - 90)
  end
end

puts ShipWithWaypoint.new('test.txt').move_all.distance
puts ShipWithWaypoint.new('input.txt').move_all.distance
