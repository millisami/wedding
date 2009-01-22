class AddInvoiceNumberToPaymentNotification < ActiveRecord::Migration
  def self.up
    add_column :payment_notifications, :invoice_number, :string
  end

  def self.down
    remove_column :payment_notifications, :invoice_number
  end
end
