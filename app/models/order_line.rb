class OrderLine < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :product
  
  # Define a sane way to label orders so we don't get labels like: #<Order:0x7e63b644>
  def to_label
   "(#{quantity}) #{product.name}"
  end
  
  # total price for this order line
  def total_price
    unit_price * quantity
  end
  
end
