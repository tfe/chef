class Product < ActiveRecord::Base
  
  has_many :order_lines
  has_many :orders, :through => :order_lines
  
  validates_presence_of :name, :price
  
end
