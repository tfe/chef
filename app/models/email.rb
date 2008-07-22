class Email < ActiveRecord::Base
  
  belongs_to :order
  
  # Define a sane way to label emails so we don't get labels like: #<Email:0x7e63b644>
  def to_label
    "#{subject}"
  end
  
end
