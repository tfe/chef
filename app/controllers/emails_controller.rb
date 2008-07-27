class EmailsController < ApplicationController
    
  active_scaffold :email do |config|
    config.columns = [:id, :to, :from, :date, :order_id, :subject, :body]
    list.columns.exclude [:body]
    list.sorting = {:date => :desc}
  end
  
end
