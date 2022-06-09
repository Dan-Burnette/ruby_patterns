# The general syntax. This is similar to try / catch in other languages.

def send_email(user, message)
  begin
    #... some process, may raise an exception
    user.mail(message)
  rescue
    #... error handler
    log_failed_email_send(user, message)
  end 
end


# You can omit the begin from a method for the same effect:
def send_email(user, message)
  user.mail(message)
rescue
  log_failed_email_send(user, message)
end 
