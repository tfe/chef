class Mailer < ActionMailer::Base
  
  def receive(email)
    Email.create(
      :to       => email.to.join(', '), 
      :from     => email.from.join(', '), 
      :reply_to => email.reply_to.join(', '), 
      :date     => email.date, 
      :subject  => email.subject, 
      :body     => email.body
    )
  end

end
