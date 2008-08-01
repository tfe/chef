class EmailObserver < ActiveRecord::Observer
  
  # parse emails before they are created
  def before_create(email)
    email.parse_to_order
  end
  
end
