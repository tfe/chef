class OrdersController < ApplicationController
  
  active_scaffold :order do |config|
    config.columns = [:id, :order_date, :ship_date, :bill_name, :email, :phone, :ship_name, :full_ship_address, :credit_card_type, :emails, :order_lines]
    create.columns.exclude [:id, :emails]
    list.sorting = {:order_date => :desc}
  end
  
end
