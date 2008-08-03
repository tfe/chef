class ChangePriceToPriceInCentsForProductsAndOrderLines < ActiveRecord::Migration
  def self.up
    
    add_column :products, :price_in_cents, :integer
    Product.reset_column_information
    Product.find(:all).each do |p|
      p.update_attribute(:price_in_cents, p.price * 100)
    end
    remove_column :products, :price
    
    add_column :order_lines, :unit_price_in_cents, :integer
    OrderLine.reset_column_information
    OrderLine.find(:all).each do |ol|
      ol.update_attribute(:unit_price_in_cents, ol.unit_price * 100)
    end
    remove_column :order_lines, :unit_price
    
  end

  def self.down
    add_column :products, :price, :decimal
    Product.reset_column_information
    Product.find(:all).each do |p|
      p.update_attribute(:price, p.price_in_cents / 100)
    end
    remove_column :products, :price_in_cents
    
    add_column :order_lines, :unit_price, :decimal
    OrderLine.reset_column_information
    OrderLine.find(:all).each do |ol|
      ol.update_attribute(:unit_price, ol.unit_price_in_cents / 100)
    end
    remove_column :order_lines, :unit_price_in_cents
  end
end
