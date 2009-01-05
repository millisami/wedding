class Modifyorders < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      #t.remove :user_id, :pay_type
      #Contact information
      t.string :email, :phone_number
      #Shipping Address
      t.string :ship_to_first_name, :ship_to_last_name, :ship_to_address1, :ship_to_address2, :ship_to_city, :ship_to_postal_code, :ship_to_country
      #Private Parts
      t.string :customer_ip, :status, :error_message
      #Extra Parts
      t.text :message
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :email, :phone_number, :ship_to_first_name, :ship_to_last_name, :ship_to_address1, :ship_to_address2, :ship_to_city, :ship_to_postal_code, :ship_to_country, :customer_ip, :status, :error_message, :message
      #t.integer :user_id
      #t.string :pay_type
    end
  end
end
