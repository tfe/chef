class EmailObserver < ActiveRecord::Observer
  
  # catch emails before they're saved and see if they are a notification email 
  # so we can parse and add the order_id to the email
  def before_save(email)
    # see if this is an order notification email
    if email.from.include? APP_CONFIG['order_notification_from_address']
      email.parse_to_order
    end
  end
  
end
