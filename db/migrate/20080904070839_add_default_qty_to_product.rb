class AddDefaultQtyToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :default_qty, :integer, :default => 35
  end

  def self.down
    remove_column :products, :default_qty
  end
end
