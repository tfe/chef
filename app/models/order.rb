class Order < ActiveRecord::Base
  
  has_many :order_lines, :dependent => true
  has_many :products, :through => :order_lines
  
end
