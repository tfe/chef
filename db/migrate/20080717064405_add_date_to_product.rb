class AddDateToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :date, :date
  end

  def self.down
    remove_column :products, :date
  end
end
