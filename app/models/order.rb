class Order < ActiveRecord::Base
  
  has_many :order_lines, :dependent => :destroy  # when orders are deleted, delete associated order lines
  has_many :products, :through => :order_lines
  
  # no validation really needed here. 
  # we'll assume CMU's e-commerce system validates everything and that our parser works
  
end
