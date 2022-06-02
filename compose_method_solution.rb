# You can extract a bunch of methods, then compose them together in another main method.
# It is pretty common to put the sub-step methods as private, since all we care about exposing is
# the entire process (no other object needs to know about adding cheese or toppings!)
#
#
# This example doesn't really add a TON of value over the more naive verison in the other file. But
# you can see how a many step process becomes a lot more readable when all you need to do is examine
# one method that composes a bunch of sub-step methods together.

class MakePizza
  def initialize(toppings)
    @toppings = toppings
  end

  def call
    build_pizza_base
    add_cheese
    add_toppings
    bake_pizza

    @pizza
  end

  private

  def build_pizza_base
    @pizza = Pizza.new
  end

  def add_cheese
    @pizza.cheese = Cheese.new
  end

  def add_toppings
    @toppings.each { |topping| @pizza.toppings << Topping.new(topping) }
  end

end

toppings = ["pepperoni", "sausage"]
pizza = MakePizza.new(toppings).call
