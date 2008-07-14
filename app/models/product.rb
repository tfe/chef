class Product < ActiveRecord::Base
  
  has_many :order_lines, :dependent => true
  has_many :orders, :through => :order_lines
  
end
