class Plane
  def initialize(file)
    @groups = IO.read(file).split("\n\n")
  end

  def counts
    len = 0
    @groups.each do |group|
      len += group.gsub("\n", "").chars.uniq.length
    end
    len
  end

  def everyone_counts
    len = 0
    @groups.each do |group|
      persons = group.split("\n")
      persons[0].each_char do |char|
        len += 1 if persons.all?{|person| person.include?(char)}
      end
    end
    len
  end
end


puts Plane.new('test.txt').counts
puts Plane.new('input.txt').counts

puts Plane.new('test.txt').everyone_counts
puts Plane.new('input.txt').everyone_counts
