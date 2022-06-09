# A recipe has many ingredients,
# which each belong to a food,
# which each have a nutrient profile

class Recipe < ApplicationRecord
  has_many :ingredients

  def food_nutrient_profiles
    ingredients.map { |ingredient| ingredient.food.nutrient_profile }
  end

end

class Ingredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :food
end

class Food < ApplicationRecord
  has_one :nutrient_profile
end

class NutrientProfile < ApplicationRecord
  belongs_to :food
end
