#  A common problem in web apps is needing to 'backfill' data.
#
#  Imagine you have a model called Product.
#  We now want to introduce the concept of a product management team.
#
#  So after writing code that will give products a product management team when created,
#  we want to run a one-time script to 'backfill' for existing products.
#  I.e. give each existing product a product management team.

# lib/tasks/once/backfill_product_management_teams.rake
namespace :once do
  desc "Create product management teams for each product, with organization admins set up as members"
  task backfill_product_management_teams: :environment do
    puts "Starting backfill process for product management teams..."

    ActiveRecord::Base.transaction do
      BackfillProductManagementTeams.new.execute
    rescue StandardError => e
      puts "Error backfilling product management teams: #{e.message}"
      puts "Rolling back the transaction"
      raise
    end

    puts "Product management teams created successfully!"
  end
end

# lib/tasks/once/impl/backfill_product_management_teams.rb
class BackfillProductManagementTeams
  def execute
    products_without_management_team.in_batches do |group| 
      group.each do |product|
        create_product_management_team(product)
        create_product_management_team_admin_memberships(product)
      end
    end
  end

  private

  def products_without_management_team
    Product.left_outer_joins(:product_management_team).where(product_management_teams: { id: nil })
  end

  def create_product_management_team(product)
    ProductManagementTeam.create!(
      product: product,
      name: "#{product.display_name}'s management team"
    )
  end

  def create_product_management_team_admin_memberships(product)
    product_management_team = ProductManagementTeam.find_by(product: product)
    product.organization.administrators.each do |admin_user|
      ProductManagementMembership.create!(user: admin_user, product_management_team: product_management_team)
    end
  end
end

# The rake task can then be run in the rails console via:
# rake once:backfill_product_management_teams

# Note the .in_batches call
# When there may be a TON of records, using .in_batches to iterate over them in groups/batches is
# often preferal to just using .each because it can load the records into memory in groups instead
# of all at once. 
#
# For instance imagine loading up 1,000,000 model objects at once to then interate over them one by
# one. It can cause issues with memory consumption.
#
# .in_batches by defaults loads things up 1,000 records at a time.
#
