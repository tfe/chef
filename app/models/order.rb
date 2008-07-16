class Order < ActiveRecord::Base
  
  has_many :order_lines, :dependent => :destroy  # when orders are deleted, delete associated order lines
  has_many :products, :through => :order_lines
  
  # no validation really needed here. 
  # we'll assume CMU's e-commerce system validates everything and that our parser works
  
  # Define a sane way to label orders so we don't get labels like: #<Order:0x7e63b644>
  def to_label
    "Order ##{id}"
  end
  
  # make it easy to refer to the whole customer name (http://railscasts.com/episodes/16)
  def full_name
    [first_name, last_name].join(' ')
  end
  def bill_name
    full_name
  end
  
  def full_name=(name)
    # we're assuming no one will ever have a space in their last name
    split = name.split(' ')
    self.last_name = split.pop
    self.first_name = split.join(' ')
  end
  def bill_name=(name)
    full_name name
  end
  
  # make it easy to refer to the whole billing address (http://railscasts.com/episodes/16)
  def full_bill_address
    # hopefully addresses never have pipes in them
    [bill_address_line_1, bill_address_line_2].join(' | ')
  end
  def full_bill_address=(address)
    split = address.split(' | ', 2)
    self.bill_address_line_1 = split.first
    self.bill_address_line_2 = split.last
  end
  
  def bill_address_line_1
    bill_address
  end
  def bill_address_line_1=(address)
    self.bill_address = address
  end
  
  def bill_address_line_2
    [bill_city, bill_state, bill_zip].join(' ')
  end
  def bill_address_line_2=(address)
    split = address.split(' ')
    # pull last two tokens off the end of array for state/zip
    self.bill_zip   = split.pop
    self.bill_state = split.pop
    self.bill_city  = split.join(' ')
  end
  
  def full_ship_address
    # hopefully addresses never have pipes in them
    [ship_address_1, ship_address_2, ship_address_3].compact.join(' | ')
  end
  def full_ship_address=(address)
    split = address.split(' | ')
    self.ship_address_1 = split.slice!(0)
    self.ship_address_2 = split.slice!(0)
    self.ship_address_3 = split.slice!(0)
  end
  
end
