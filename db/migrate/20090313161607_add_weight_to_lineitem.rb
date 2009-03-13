class AddWeightToLineitem < ActiveRecord::Migration
  def self.up
      add_column :line_items, :weight, :float, :default => 1000
  end

  def self.down
      remove_column :line_items, :weight
  end
end
