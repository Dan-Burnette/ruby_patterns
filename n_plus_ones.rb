class Branch < ApplicationRecord
  has_many :builds
end

class Build < ApplicationRecord
  belongs_to :branch
end

# Slow way, contains a so called N + 1 query

builds = Build.order(:finished_at).limit(10)

builds.each do |build|
  puts "#{build.branch.name} build number #{build.number}"
end

# Runs database queries:
# Build Load (1.7ms) SELECT "builds".* FROM "builds" ORDER BY "builds"."finished_at" ASC LIMIT 10
# Branch Load (0.4ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 11]]
# Branch Load (0.8ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 13]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 15]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 17]]
# Branch Load (0.2ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 19]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 111]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 113]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 115]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 117]]
# Branch Load (0.3ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" = $1 LIMIT 1 [["id", 119]]

# Faster way to load the same items (use includes) => this is called eager loading
builds = Build.order(:finished_at).includes(:branches).limit(10)

builds.each do |build|
  puts "#{build.branch.name} build number #{build.number}"
end

# Build Load (0.5ms) SELECT "builds".* FROM "builds" ORDER BY "builds"."finished_at" ASC LIMIT 10
# Branch Load (0.5ms) SELECT "branches".* FROM "branches" WHERE "branches"."id" IN (11, 13, 15, 17, 19, 111, 113, 115, 117, 119)

#Uses only two database queries!
#With the first approach, 10,000 branches would make 10,000 database queries.
#With the second approach, 10,000 branches would make just 2 database queries.
#

# There are various gems you can install in a project to detect N+1 queries and/or prevent their
# introduction into the code base. They typically log N+1s to the server log, but can be configured
# to raise an error ("aggressive N+1 prevention").
# https://github.com/charkost/prosopite
#
# Often when you see an N+1 query your first move should be to try and eager load the thing causing
# it via #includes.
