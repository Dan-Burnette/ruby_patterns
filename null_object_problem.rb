# You'll sometimes run into code that fits the pattern:

if object.nil?
  do_this
else
  object.do_that
else

# Here is a more realistic example:

class User < ApplicationRecord

  has_many :accounts

  def savings_account
    accounts.find_by(savings: true) 
  end

  def chequing_account
    accounts.find_by(chequing: true)
  end

  def investment_account
    accounts.find_by(investment: true)
  end

end


# PROBLEM:
# Whenever the user does not have a savings_account / chequing_account / investment_account,
# We will need to make conditionals to handle that situation.
#
# e.g:

if user.savings_account.present?
  user.savings_account.available_balance_cents
else
  0
end

