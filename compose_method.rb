class MakePizza
  def initialize(toppings)
    @toppings = toppings
  end

  def call
    pizza = Pizza.new
    pizza.cheese = Cheese.new
    @toppings.each { |topping| pizza.toppings << Topping.new(topping) }

    pizza
  end
end

toppings = ["pepperoni", "sausage"]
pizza = MakePizza.new(toppings).call
