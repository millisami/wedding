class ChangeCartIdToOrderIdInPaymentNotification < ActiveRecord::Migration
  def self.up
    remove_column :payment_notifications, :cart_id
    add_column :payment_notifications, :order_id, :integer
    #User.update_all ["receive_newsletter = ?", true]
    #execute "ALTER TABLE products ADD CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories(id)"
  end

  def self.down
    #execute "ALTER TABLE products DROP FOREIGN KEY fk_products_categories"
    remove_column :payment_notifications, :order_id
    add_column :payment_notifications, :cart_id, :integer
  end
end
