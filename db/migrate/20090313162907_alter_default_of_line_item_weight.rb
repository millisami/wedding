class AlterDefaultOfLineItemWeight < ActiveRecord::Migration
  def self.up
      change_table :line_items do |t|
          t.change_default :weight, 0
      end
  end

  def self.down
      change_table :line_items do |t|
          t.change_default :weight, 1000
      end
  end
end
