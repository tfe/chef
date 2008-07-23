class Email < ActiveRecord::Base
  
  belongs_to :order
  
  # Define a sane way to label emails so we don't get labels like: #<Email:0x7e63b644>
  def to_label
    "#{subject}"
  end
  
  def parse_to_order
    # get a hash of the order data in the email (foo=bar stuff)
    h = to_hash
    
    # create an order with the ones we want
    o = Order.create(
      :first_name       => h['First_Name'], 
      :last_name        => h['Last_Name'], 
      :email            => h['Email'], 
      :phone            => h['Phone'], 
      :bill_address     => h['Bill_Address'], 
      :bill_city        => h['Bill_City'], 
      :bill_state       => h['Bill_State'], 
      :bill_zip         => h['Bill_Zip'], 
      :bill_country     => h['Bill_Country'], 
      :ship_name        => h['Flex_Field1'], 
      :ship_address_1   => h['Flex_Field2'], 
      :ship_address_2   => h['Flex_Field3'], 
      :ship_address_3   => h['Flex_Field4'], 
      :credit_card_type => h['Card_Type'], 
      # first three words of the merchent ref number are the date and time
      :order_date       => h['Merchant_Ref_No'].split.first(4).join(' ')
    )
    
    o
  end
  
  # return a reprentation of the email body as a hash
  def to_hash
    h = {}
    body.each_line do |line|
      # split each line on the equals sign
      words = line.split('=', 2)
      # strip whitespace
      words.each {|word| word.strip! }
      # unless one of the words is blank, put them in the hash
      unless words.first.blank? or words.last.blank?
        h[words.first] = words.last
      end
    end
    h
  end
  
end
