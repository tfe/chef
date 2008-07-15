class AddImageUrlsToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :image_url_small, :string
    add_column :products, :image_url_large, :string
  end

  def self.down
    remove_column :products, :image_url_large
    remove_column :products, :image_url_small
  end
end
