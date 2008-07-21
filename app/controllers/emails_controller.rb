class EmailsController < ApplicationController
    
  active_scaffold :email do |config|
    config.columns = [:to, :from, :date, :subject, :body]
    list.columns.exclude [:body]
    list.sorting = {:date => :desc}
  end
  
end
