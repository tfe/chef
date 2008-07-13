class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :bill_address
      t.string :bill_city
      t.string :bill_state
      t.string :bill_zip
      t.string :bill_country
      t.string :ship_name
      t.string :ship_address_1
      t.string :ship_address_2
      t.string :ship_address_3
      t.string :credit_card_type
      t.date :order_date
      t.date :ship_date

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
