class CreateOrderLines < ActiveRecord::Migration
  def self.up
    create_table :order_lines do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :order_lines
  end
end
