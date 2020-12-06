class Plane
  def initialize(file)
    @groups = IO.read(file).split("\n\n")
  end

  def counts
    @groups.inject(0) do |sum, group|
      sum + group.gsub("\n", "").chars.uniq.length
    end
  end

  def everyone_counts
    @groups.inject(0) do |sum, group|
      persons = group.split("\n")
      sum + persons[0].chars.inject(0) do |psum, char|
        psum + (persons.all?{|person| person.include?(char)} ? 1 : 0)
      end
    end
  end
end


puts Plane.new('test.txt').counts
puts Plane.new('input.txt').counts

puts Plane.new('test.txt').everyone_counts
puts Plane.new('input.txt').everyone_counts
