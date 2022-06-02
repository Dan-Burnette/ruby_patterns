class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def completion_notification(first_name, last_name, address, email)
    @first_name = first_name
    @last_name = last_name
    @address = address
    @email = email
    mail(
      to: email,
      subject: 'Thank you for completing the survey'
    )
  end
end
