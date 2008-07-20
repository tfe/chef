class Mailer < ActionMailer::Base
  
  def receive(email)
    # just dumping basic parts of the email to console for now until persisting to database is implemented
    puts email.to
    puts email.from
    puts email.subject
    puts email.body
  end

end
