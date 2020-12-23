require 'set'
class Food
  def initialize(allergen_file)
    @allergens = {}
    @all_foods = Hash.new(0)
    IO.readlines(allergen_file, chomp: true).each do |line|
      line_foods, contains = line.split(' (contains ')
      foods = Set.new(line_foods.split(' '))
      foods.each{|food| @all_foods[food] += 1}
      contains.gsub(')', '').split(', ').each do |allergen|
        if @allergens.has_key?(allergen)
          @allergens[allergen] &= foods
        else
          @allergens[allergen] = foods
        end
      end
    end
  end

  def non_allergenics
    allergen_foods = @allergens.values.inject(&:union)
    @all_foods.map{|k, v| allergen_foods.include?(k) ? 0 : v}.sum
  end

  def canonical_danger
    @allergens.select{|k, v| v.length == 1}.each do |allergen, foods|
      @allergens.each{|k, v| @allergens[k].delete(foods.first) unless k == allergen}
    end while @allergens.any?{|k, v| v.length > 1}
    @allergens.sort.map{|k, v| v.first}.join(',')
  end
end

puts Food.new('sample.txt').non_allergenics
puts Food.new('input.txt').non_allergenics

puts Food.new('sample.txt').canonical_danger
puts Food.new('input.txt').canonical_danger
