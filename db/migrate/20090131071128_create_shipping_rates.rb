class CreateShippingRates < ActiveRecord::Migration
  def self.up
    create_table :shipping_rates do |t|
      t.decimal :weight, :precision => 8, :scale => 2, :null => false, :default => 0
      t.decimal :rate_euro, :precision => 8, :scale => 2, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_rates
  end
end
