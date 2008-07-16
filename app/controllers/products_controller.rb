class ProductsController < ApplicationController
  
  active_scaffold :product do |config|
    config.columns = [:name, :price, :short_description, :description, :image_url_small, :image_url_large]
    config.subform.columns = [:name, :price]
    list.columns.exclude [:image_url_small, :image_url_large]
    list.sorting = {:created_at => :desc}
  end
  
end
