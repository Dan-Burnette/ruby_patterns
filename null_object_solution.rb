# https://medium.com/@kelseydh/using-the-null-object-pattern-with-ruby-on-rails-b645ebf79785
# Solution: Use a NULL OBJECT
#
# The goal of the Null Object pattern is to abstract the harms of NULL data away. Rather than returning nil, we return a reliable version of nil-like account which gives us sensible defaults:

class NullAccount

  def available_balance_cents
    0
  end

end

class User < ApplicationRecord

  has_many :accounts

  def savings_account
    accounts.find_by(savings: true) || NullAccount.new
  end

  def chequing_account
    accounts.find_by(chequing: true) || NullAccount.new
  end

  def investment_account
    accounts.find_by(investment: true) || NullAccount.new
  end

end


# Now we can call:
user.savings_account.available_balance_cents

# => return the available cents if they have a savings account, or 0 if they don't
