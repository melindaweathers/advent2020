class PassportBatch
  REQS = %w[byr iyr eyr hgt hcl ecl pid]

  def initialize(filename)
    @batch = IO.read(filename).split("\n\n")
  end

  def count_valid
    @batch.select{|passp| valid_pass?(passp)}.length
  end

  def count_valid2
    @batch.select{|passp| valid_pass2?(passp)}.length
  end

  def valid_pass?(passp)
    REQS.all?{|req| passp.include?("#{req}:")}
  end

  def valid_pass2?(passp)
    valid_pass?(passp) && REQS.all? {|req| send("valid_#{req}?", passp.match(/#{req}:([^\s]+)/)[1]) }
  end

  def valid_byr?(byr)
    byr.to_i <= 2002 && byr.to_i >= 1920
  end

  def valid_iyr?(iyr)
    iyr.to_i <= 2020 && iyr.to_i >= 2010
  end

  def valid_eyr?(eyr)
    eyr.to_i <= 2030 && eyr.to_i >= 2020
  end

  def valid_hgt?(hgt)
    val = hgt.to_i
    if hgt.include?('cm')
      val <= 193 && val >= 150
    elsif hgt.include?('in')
      val <= 76 && val >= 59
    else
      false
    end
  end

  def valid_hcl?(hcl)
    hcl =~ /^#[0-9a-f]{6}$/
  end

  def valid_ecl?(ecl)
    %w[amb blu brn gry grn hzl oth].include?(ecl)
  end

  def valid_pid?(pid)
    pid =~ /^[0-9]{9}$/
  end
end

puts PassportBatch.new('test.txt').count_valid
puts PassportBatch.new('input.txt').count_valid


puts PassportBatch.new('invalid.txt').count_valid2
puts PassportBatch.new('valid.txt').count_valid2
puts PassportBatch.new('input.txt').count_valid2
