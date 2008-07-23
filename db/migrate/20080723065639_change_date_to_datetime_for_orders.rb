class ChangeDateToDatetimeForOrders < ActiveRecord::Migration
  def self.up
    change_column :orders, :order_date, :datetime
  end

  def self.down
    change_column :orders, :order_date, :date
  end
end
