class AddWeightToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :weight, :float, :default => 1000
  end

  def self.down
    remove_column :products, :weight
  end
end
