class ProductsController < ApplicationController
  
  active_scaffold :product do |config|
    config.columns = [:name, :sku, :price, :date, :short_description, :description, :image_url_small, :image_url_large]
    config.subform.columns = [:name, :price]
    list.columns.exclude [:image_url_small, :image_url_large]
    list.sorting = {:date => :desc}
  end
  
end
