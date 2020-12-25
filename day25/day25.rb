class ComboBreaker
  def initialize(card_pub, door_pub)
    @card_pub = card_pub
    @door_pub = door_pub
  end

  def break
    card_loop_size = calc_loop_size(@card_pub)
    encryption_key = transform(@door_pub, card_loop_size)
  end

  def transform(subject, loop_size)
    val = 1
    loop_size.times { val = single_loop(subject, val) }
    val
  end

  def single_loop(subject, val)
    (val * subject) % 20201227
  end

  def calc_loop_size(pub_key)
    try = 1
    val = 1
    try += 1 until (val = single_loop(7, val)) == pub_key
    try
  end
end

puts ComboBreaker.new(5764801, 17807724).break
puts ComboBreaker.new(3248366, 4738476).break
