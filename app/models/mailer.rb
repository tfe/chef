class Mailer < ActionMailer::Base
  
  def receive(email)
    Email.create(
      :to       => email.to.join(', '), 
      :from     => email.from.join(', '), 
      :reply_to => email.reply_to.join(', '), 
      :date     => email.date, 
      :subject  => email.subject, 
      :body     => body_as_plain_text(email)
    )
  end
  
  def confirmation(order)
    recipients    order.email_with_name
    # Gmail will always use the address you're authenticated as when sending for the "from". 
    # Setting it like this allows us to use the email address with a name.
    from          APP_CONFIG['order_confirmation_email']['from_address_with_name'] 
    reply_to      APP_CONFIG['order_confirmation_email']['reply-to_address_with_name']
    subject       APP_CONFIG['order_confirmation_email']['subject']
    sent_on       Time.now
  end
  
  
  private 
  
  # get the body as plain text
  # derived from: http://lists.rubyonrails.org/pipermail/rails/2006-May/043429.html
  def body_as_plain_text(part)
    body = ''
    if part.multipart?
      part.parts.each do |subpart|
        if subpart.content_type == 'text/plain' and
           (subpart.content_disposition.nil? or 
            subpart.content_disposition == 'inline')
          body << subpart.body
        elsif subpart.content_type =~ /^multipart/
          body << body_as_plain_text(subpart)
        end
      end
    else
      body = part.body
    end
    body
  end
  
end
