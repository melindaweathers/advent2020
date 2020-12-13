def which_bus(earliest, buses)
  best_offset = best_bus = 10000000
  buses.map(&:to_i).each do |bus|
    best_offset, best_bus = [how_long(earliest, bus), bus] if bus > 0 && how_long(earliest, bus) < best_offset
  end
  best_offset*best_bus
end

def how_long(earliest, bus)
  bus - (earliest % bus)
end

earliest_sample = 939
buses_sample = "7,13,x,x,59,x,31,19".split(',')
puts which_bus(earliest_sample, buses_sample)

earliest = 1006697
buses = "13,x,x,41,x,x,x,x,x,x,x,x,x,641,x,x,x,x,x,x,x,x,x,x,x,19,x,x,x,x,17,x,x,x,x,x,x,x,x,x,x,x,29,x,661,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,23".split(',')
puts which_bus(earliest, buses)

def alignment(buses)
  bus_map = build_bus_map(buses)
  keys = bus_map.keys
  t = 0
  step = 1
  locking = 0

  loop do
    bus = keys[locking]
    i = bus_map[bus]
    if (t + i) % bus == 0
      locking += 1
      step *= bus
      puts bus_map.map { |bus, i| (t + i) % bus }.inspect
    end
    break if locking >= keys.length
    t += step
  end
  t
end

def build_bus_map(buses)
  map = {}
  buses.each_with_index do |bus, i|
    next if bus.to_i == 0
    map[bus.to_i] = i
  end
  map
end

puts 'should be 3417'
puts alignment('17,x,13,19'.split(','))

puts 'should be 1068788'
puts alignment(buses_sample)

puts 'should be 754018'
puts alignment('67,7,59,61'.split(','))

puts 'should be 779210'
puts alignment('67,x,7,59,61'.split(','))

puts 'should be 1261476'
puts alignment('67,7,x,59,61'.split(','))

puts 'should be 1202161486'
puts alignment('1789,37,47,1889'.split(','))

puts 'second star'
puts alignment(buses)
