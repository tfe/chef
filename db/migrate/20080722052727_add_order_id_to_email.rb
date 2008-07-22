class AddOrderIdToEmail < ActiveRecord::Migration
  def self.up
    add_column :emails, :order_id, :integer
  end

  def self.down
    remove_column :emails, :order_id
  end
end
