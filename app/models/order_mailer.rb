class OrderMailer < ActionMailer::Base
  
  # process emails, generally from Fetcher
  # returns normally or raises an exception based on whether email was processed succesfully
  # (in this context, whether it was an order notification email or not)
  def receive(email)
    unless email.from.include? APP_CONFIG['order_notification_from_address']
      logger.info "Email rejected, not an order notification: #{email.subject}"
      raise "Not an order notification email"
    end
    logger.info "Creating email: #{email.subject}"
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
    # keep from sending emails to random people in dev and testing environments
    if RAILS_ENV == 'production'
      recipients  order.email_with_name
    else
      recipients  APP_CONFIG['order_confirmation_email']['test_recipient'] 
    end
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
