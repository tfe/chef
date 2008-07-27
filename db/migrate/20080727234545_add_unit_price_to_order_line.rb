class AddUnitPriceToOrderLine < ActiveRecord::Migration
  def self.up
    add_column :order_lines, :unit_price, :decimal
  end

  def self.down
    remove_column :order_lines, :unit_price
  end
end
