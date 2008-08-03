# A bunch of one-off methods that I needed to accomplish various tasks.
# DO NOT use these, they are not for general consumption and may (probably will) do strange things to the database.


namespace :tfe do

  task :load_sales_tax => :environment do
    
    tax_product = Product.find_by_sku(1000)
    
    emails = Email.find(:all)
    
    emails.each do |email|
      
      next if email.order_id.blank?
      
      order = Order.find(email.order_id)
      
      # get a hash of the order data in the email (foo=bar stuff)
      body_as_h = {}
      email.body.each_line do |line|
        # split each line on the equals sign
        words = line.split('=', 2)
        # strip whitespace
        words.each {|word| word.strip! }
        # unless one of the words is blank, put them in the hash
        unless words.first.blank? or words.last.blank? or words.size < 2
          body_as_h[words.first] = words.last
        end
      end
      
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
        
        next unless item['Name'] == 'Sales Tax'
        price = Money.new(item['Price_Each'])
        break if price.zero?
        
        OrderLine.create(
          :product  => tax_product,
          :order    => order,
          :quantity => 1,
          :unit_price => item['Price_Each']
        )
      end
      
    end
    
  end
  
  
  

  task :load_orders => :environment do
    
    # This would need to be tweaked before being used... I just yanked it straight out of the Email model.
    # When it actually was used it was in Email.parse_to_order and called by the email observer during a mail fetch fetching all the old order emails. Calling it as a rake task would probably do strange things.
    # I'm just keeping the code here for potential future use should it be needed.
    
=begin
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
    
    # quit if notification has an error flag
    return if body_as_h.include? 'Error_Flag'
    
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
      item['Sku'] = case item['Name']
        when '2008 Buggy DVD - Raceday DVD and Bonus Video': '1010'
        when '2007 Buggy DVD - Raceday DVD and Bonus Video': '1009'
        when '2006 Buggy DVD': '1008'
        when '2005 Buggy DVD': '1007'
        when '2004 Buggy DVD': '1006'
        when '2003 Buggy DVD': '1005'
        when 'Greek Sing 2008': '1004'
        when 'Mr. Fraternity 2008': '1003'
        when 'One Night in Beijing - Presented by ARCC, 2007': '1002'
        when 'Bhangra in the Burgh - November 3, 2007': '1001'
      end
      unless item['Sku'].blank?  # keep blank SKUs out (filter out sales tax item)
        product = Product.find_by_sku(item['Sku'])
        OrderLine.create(
          :product  => product,
          :order    => order,
          :quantity => item['Qty'],
          :unit_price => item['Price_Each']
        )
      end
    end
    
    # now we have an order id to save with this email
    # since we call this parse method before saving emails, setting the order_id here works
    self.order_id = order.id
=end
  end
  
end