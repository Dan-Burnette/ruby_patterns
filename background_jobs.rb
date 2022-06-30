# Background jobs
#
# A "background job" is that a web app runs outside of the standard request/response cycle
# (i.e. 'in the background').
#
# Common use case:
#
# - When the task would take too long to do in a single request, i.e. we don't want to show the user
# a 30 minute loader for some crazy computational task, so instead we put into a background job that
# will email the user once complete.
#
# Sidekiq as a job queuing backend to perform units of work asynchronously in the background.


# app/services/update_food.rb
class UpdateFood < ApplicationService
  class NotValidFoodRecord < StandardError
  end

  def initialize(food, params)
    @food = food
    @params = params
  end

  def call
    @food.assign_attributes(@params)

    @food.nutrient_data = FetchNutrientData.call(@food)

    if @food.valid?
      @food.save!
      calculate_affected_ingredient_stats
      calculate_affected_recipe_stats
      calculate_affected_day_stats_later
      calculate_affected_combo_stats_later
      build_meal_plan_shopping_lists_later
    else
      raise(NotValidFoodRecord, @food.errors.full_messages.to_sentence)
    end
  end

  private

  def affected_ingredients
    @affected_ingredients ||= FoodIngredientsQuery.call(@food)
  end

  def calculate_affected_ingredient_stats
    affected_ingredients.each do |ingredient|
      ingredient.calculate_nutrient_stats
      ingredient.save!
    end
  end

  def affected_recipes
    @affected_recipes ||= get_affected_recipes
  end

  def get_affected_recipes
    ingredients_attached_to_recipe =
      affected_ingredients.select { |i| !i.add_on? }
    ingredients_attached_to_recipe.map(&:recipe)
  end

  def calculate_affected_recipe_stats
    affected_recipes.each do |recipe|
      recipe.calculate_stats
      recipe.save!
    end
  end

  def affected_days
    affected_ingredients.inject([]) { |days, i| days += i.days }
  end

  def calculate_affected_day_stats_later
    day_ids = affected_days.pluck(:id)
    day_ids.each { |id| CalculateDayStatsJob.perform_later(id) }
  end

  def affected_combo_ids
    recipe_ids = affected_recipes.map(&:id)
    ValidCombo
      .where("valid_combos.asc_recipe_ids && '{#{recipe_ids.join(',')}}'")
      .pluck(:id)
  end

  def calculate_affected_combo_stats_later
    affected_combo_ids.each { |id| CalculateComboStatsJob.perform_later(id) }
  end

  def build_meal_plan_shopping_lists_later
    plans =
      affected_ingredients.inject([]) { |arr, i| arr += i.meal_plans }.uniq
    plans.each { |plan| BuildShoppingListJob.perform_later(plan.id) }
  end
end


# app/jobs/calculate_day_stats_job.rb
class CalculateDayStatsJob < ApplicationJob
  queue_as :default

  def perform(day_id)
    day = Day.find(day_id)
    day.calculate_stats
    day.save!
  end
end

# app/jobs/calculate_combo_stats_job.rb
class CalculateComboStatsJob < ApplicationJob
  queue_as :default

  def perform(combo_id)
    combo = ValidCombo.find(combo_id)
    combo.calculate_stats
    combo.save!
  end
end

# app/jobs/build_shopping_list_job.rb
class BuildShoppingListJob < ApplicationJob
  queue_as :default

  def perform(meal_plan_id)
    meal_plan = MealPlan.find(meal_plan_id)
    meal_plan.build_shopping_list
    meal_plan.save!
  end
end


# You will notice that these job classes inherit from ApplicationJob.
# This is the rails provided Job handler: https://edgeguides.rubyonrails.org/active_job_basics.html
#
# # 1 What is Active Job?
# Active Job is a framework for declaring jobs and making them run on a variety of queuing backends.
# These jobs can be everything from regularly scheduled clean-ups, to billing charges, to mailings.
# Anything that can be chopped up into small units of work and run in parallel, really.
#
# Activejob is commonly used in conjunction with the Sidekiq gem as the queueing backend:
# https://github.com/mperham/sidekiq
#
# Typically you set this up with a bunch of job "workers". Each "worker" runs on it's own thread.
# This is referred to as "concurrency" - just means running multiple tasks ('jobs') in parallel.
#
# You configure sidekiq with the amount of "workers" to run, e.g:

# config/sidekiq_worker.yml
:concurrency: 25
:queues:
  - ["priority", 3]
  - ["default", 2]
  - ["low", 1]

# This would then set up 25 sidekiq workers than can each perform a task from the queue. So you can
# have 25 tasks running in parallel.

# So basically, you can queue up 100,000 jobs and process them 25 at a time with this setup.

