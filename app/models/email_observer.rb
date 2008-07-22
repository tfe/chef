class EmailObserver < ActiveRecord::Observer
  
  def after_create(email)
    # see if this is an order notification email
  end
  
end
