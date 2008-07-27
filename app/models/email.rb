class Email < ActiveRecord::Base
  
  belongs_to :order
  
  # Define a sane way to label emails so we don't get labels like: #<Email:0x7e63b644>
  def to_label
    "#{subject}"
  end
  
  def parse_to_order
    
    # get a hash of the order data in the email (foo=bar stuff)
    body_as_h = {}
    body.each_line do |line|
      # split each line on the equals sign
      words = line.split('=', 2)
      # strip whitespace
      words.each {|word| word.strip! }
      # unless one of the words is blank, put them in the hash
      unless words.first.blank? or words.last.blank? or words.size < 2
        body_as_h[words.first] = words.last
      end
    end
    
    # create an order with the fields we want
    order = Order.create(
      :first_name       => body_as_h['First_Name'], 
      :last_name        => body_as_h['Last_Name'], 
      :email            => body_as_h['Email'], 
      :phone            => body_as_h['Phone'], 
      :bill_address     => body_as_h['Bill_Address'], 
      :bill_city        => body_as_h['Bill_City'], 
      :bill_state       => body_as_h['Bill_State'], 
      :bill_zip         => body_as_h['Bill_Zip'], 
      :bill_country     => body_as_h['Bill_Country'], 
      :ship_name        => body_as_h['Flex_Field1'], 
      :ship_address_1   => body_as_h['Flex_Field2'], 
      :ship_address_2   => body_as_h['Flex_Field3'], 
      :ship_address_3   => body_as_h['Flex_Field4'], 
      :credit_card_type => body_as_h['Card_Type'], 
      # apparently there is nothing in the notify email to indicate the order date/time, so we use the email date
      :order_date       => self.date
    )
    
    # 
    # parse out order's products (items) and quantities for order_lines
    # 
    items = []
    item = {'not blank' => 'to start with'}
    
    until item.blank?           # continue looking for items until we stop finding them
      
      item_string ||= 'Item0_'  # set item counter/string if not already set
      item_string.next!         # go the next item each time around the loop
      
      # get item info pairs that start with the current item_string
      item = Hash[ body_as_h.select { |key, value| key.start_with? item_string } ]
      
      # clean item info keys to remove item-specificity (Qty instead of Item1_Qty)
      item.each_pair do |key, value|
        item.delete key                          # delete old pair with specific key
        item[key.sub(item_string, '')] = value   # create new pair with generic key
      end
      
      # store in items array if not blank 
      # the last run will yield a blank item, that's how we know to stop, but we don't want to keep it
      unless item.blank?
        items << item
      end
    end
    
    
    # 
    # find the actual Products in array of items, create order lines
    # 
    items.each do |item|
      unless item['Sku'].blank?  # keep blank SKUs out (filter out sales tax item)
        product = Product.find_by_id(item['Sku'])
        OrderLine.create(
          :product  => product,
          :order    => order,
          :quantity => item['Qty']
        )
      end
    end
    
    # now we have an order id to save with this email
    # since we call this parse method before saving emails, setting the order_id here works
    self.order_id = order.id
  end
  
end
