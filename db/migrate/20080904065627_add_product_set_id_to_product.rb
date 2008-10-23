class AddProductSetIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :product_set_id, :integer
  end

  def self.down
    remove_column :products, :product_set_id
  end
end
