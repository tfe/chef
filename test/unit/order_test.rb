require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  # 
  # name tests
  # 
  def test_full_name_get
    assert_equal 'John Doe', full_name('John', 'Doe'), 'standard name'
    assert_equal 'John James Doe', full_name('John James', 'Doe'), 'first name with spaces'
    assert_equal 'John James Doe', full_name('John', 'James Doe'), 'last name with spaces'
  end
  
  def test_full_name_set
    order = Order.new(:full_name => 'John Doe')
    assert_equal 'John', order.first_name, 'standard name (first)'
    assert_equal 'Doe', order.last_name, 'standard name (last)'
    
    order = Order.new(:full_name => 'John James Doe')
    assert_equal 'John James', order.first_name, 'name with spaces (first)'
    assert_equal 'Doe', order.last_name, 'name with spaces (last)'
  end
  
  def full_name(first, last)
    Order.new(:first_name => first, :last_name => last).full_name
  end
  
  
  # 
  # address tests
  # 
  def test_full_bill_address_get
    order = Order.new(:bill_address_line_1 => '244 S Ardmore Rd', :bill_address_line_2 => 'Columbus OH 43209')
    assert_equal '244 S Ardmore Rd | Columbus OH 43209', order.full_bill_address, 'standard address'
  end
  def test_full_bill_address_set
    order = Order.new(:full_bill_address => '244 S Ardmore Rd | Columbus OH 43209')
    assert_equal '244 S Ardmore Rd', order.bill_address_line_1, 'standard address (line 1)'
    assert_equal 'Columbus OH 43209', order.bill_address_line_2, 'standard address (line 2)'
  end
  
  def test_bill_address_line_2_get
    # standard address
    order = Order.new(:bill_city => 'Columbus', :bill_state => 'OH', :bill_zip => '43209')
    assert_equal 'Columbus OH 43209', order.bill_address_line_2, 'standard address'
    # two-word city name
    order = Order.new(:bill_city => 'Maple Grove', :bill_state => 'OH', :bill_zip => '43209')
    assert_equal 'Maple Grove OH 43209', order.bill_address_line_2, 'two-word city name'
  end
  def test_bill_address_line_2_set
    order = Order.new(:bill_address_line_2 => 'Columbus OH 43209')
    assert_equal 'Columbus', order.bill_city, 'standard address (city)'
    assert_equal 'OH',       order.bill_state, 'standard address (state)'
    assert_equal '43209',    order.bill_zip, 'standard address (zip)'
    
    order = Order.new(:bill_address_line_2 => 'Maple Grove OH 43209')
    assert_equal 'Maple Grove', order.bill_city, 'two-word city name (city)'
    assert_equal 'OH',          order.bill_state, 'two-word city name (state)'
    assert_equal '43209',       order.bill_zip, 'two-word city name (zip)'
  end
  
  def test_full_ship_address_get
    # standard address
    order = Order.new(:ship_address_1 => '244 S Ardmore Rd', :ship_address_2 => 'Columbus OH 43209')
    assert_equal '244 S Ardmore Rd | Columbus OH 43209', order.full_ship_address, 'standard address'
    # three-line address
    order = Order.new(:ship_address_1 => '5032 Forbes Ave', :ship_address_2 => 'SMC 7342', :ship_address_3 => 'Pittsburgh, PA 15213')
    assert_equal '5032 Forbes Ave | SMC 7342 | Pittsburgh, PA 15213', order.full_ship_address, 'three-line address'
  end
  def test_full_ship_address_set
    # standard address
    order = Order.new(:full_ship_address => '244 S Ardmore Rd | Columbus OH 43209')
    assert_equal '244 S Ardmore Rd', order.ship_address_1, 'standard address (line 1)'
    assert_equal 'Columbus OH 43209', order.ship_address_2, 'standard address (line 2)'
    assert_nil order.ship_address_3, 'standard address (line 3 not nil)'
    # three-line address
    order = Order.new(:full_ship_address => '5032 Forbes Ave | SMC 7342 | Pittsburgh, PA 15213')
    assert_equal '5032 Forbes Ave', order.ship_address_1, 'three-line address (line 1)'
    assert_equal 'SMC 7342', order.ship_address_2, 'three-line address (line 2)'
    assert_equal 'Pittsburgh, PA 15213', order.ship_address_3, 'three-line address (line 3)'
  end
  
end
