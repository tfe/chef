class AddSkuToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :sku, :integer
  end

  def self.down
    remove_column :products, :sku
  end
end
