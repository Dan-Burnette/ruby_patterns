# Solutions used here:
# • *Introduce parameter object* and pass it in as an object of naturally grouped attributes.

class Mailer < ActionMailer::Base
  default from: "from@example.com"

  # Then the mail template can just do @user.first_name, @user.last_name, @user.address etc. where needed.
  def completion_notification(user)
    @user = user 
    mail(
      to: user.email,
      subject: 'Thank you for completing the survey'
    )
  end
end
