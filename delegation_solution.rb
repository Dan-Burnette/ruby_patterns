class Recipe < ApplicationRecord
  has_many :ingredients

  # Now we can just get the nutrient profile from the ingredient:
  def food_nutrient_profiles
    ingredients.map { |ingredient| ingredient.nutrient_profile }
  end

end

class Ingredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :food

  # Delegate means that when the ingredient receives a nutrient_profile method call,
  # instead of processing that itself, it will send the method along to :food
  delegate :nutrient_profile, to: :food
end

class Food < ApplicationRecord
  has_one :nutrient_profile
end

class NutrientProfile < ApplicationRecord
  belongs_to :food
end

# Mostly it can just make code a bit easier to read.
#
# Delegation can be used for other things as well though, so it's a handy idea to keep in the
# toolbox. It often comes up when dealing with the "Proxy" design pattern.


