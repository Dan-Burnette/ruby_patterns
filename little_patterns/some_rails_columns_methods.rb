# Pretend the user has an :email column in the database.

# Rails will use (metaprogramming  - code that writes code) to give automatically define certain
# methods. Here are some of the things rails gives you...

# Instead of 
User.find_by(email: "test@test.com")

# You can do:
User.find_by_email("test@test.com")

# The same pattern holds for any other columns on the User
User.find_by_any_other_column("column value")

# Now say we have a boolean column on the user table: 'subscribed'
test_user  = User.find_by_email("test@test.com")

# You might naturally do:
test_user.subscribed

# But rails provides a more expressive method to interact with boolean attributes:
test_user.subscribed?

# The .subscribed?  method is another method created by rails doing metaprogramming based on your
# column name. The question mark makes it very clear that subscribed is a boolean - true or
# false. This is a common convention used when writing rails code - methods that end with a question
# mark return booleans.

class User < ApplicationRecord

  # You can define your own question mark methods too! Make sure it always returns a boolean or
  # other developers will be confused:
  def signed_in_this_year?
    last_sign_in_at > 1.year.ago
  end

  def eligible_for_promotional_email?
    subscribed? && signed_in_this_year?
  end

end
