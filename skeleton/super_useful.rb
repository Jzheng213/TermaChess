require 'byebug'
# PHASE 2
def convert_to_int(str)
  Integer(str)
rescue TypeError
  p "can't convert to Int"
ensure
  num ||= nil
end

# PHASE 3
FRUITS = ["apple", "banana", "orange"]
CoffeeError = Class.new(StandardError)

def reaction(maybe_fruit)
  if FRUITS.include? maybe_fruit
    puts "OMG, thanks so much for the #{maybe_fruit}!"
  elsif maybe_fruit == 'coffee'
    raise CoffeeError.new("coffee error")
  else
    raise StandardError
  end
end

def feed_me_a_fruit
  puts "Hello, I am a friendly monster. :)"

  puts "Feed me a fruit! (Enter the name of a fruit:)"
  begin
    maybe_fruit = gets.chomp
    reaction(maybe_fruit)
  rescue CoffeeError => e
    p e.message
    # p "Thanks for coffee, try to feed again:"
    retry
  rescue StandardError
    p "I don't eat this, bye"
  end
end


LessThanFiveYearsError = Class.new(StandardError)
NoStringError = Class.new(StandardError)
# PHASE 4
class BestFriend
  def initialize(name, yrs_known, fav_pastime)
    raise LessThanFiveYearsError if yrs_known < 5
    raise NoStringError if name.length <= 0 || fav_pastime.length <= 0
    @name = name
    @yrs_known = yrs_known
    @fav_pastime = fav_pastime
  end

  def talk_about_friendship
    puts "Wowza, we've been friends for #{@yrs_known}. Let's be friends for another #{1000 * @yrs_known}."
  end

  def do_friendstuff
    puts "Hey bestie, let's go #{@fav_pastime}. Wait, why don't you choose. 😄"
  end

  def give_friendship_bracelet
    puts "Hey bestie, I made you a friendship bracelet. It says my name, #{@name}, so you never forget me."
  end
end
