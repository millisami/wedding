class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_purchased

  private
  def mark_order_as_purchased
    if status == "Completed" && params[:secret] == APP_CONFIG[:paypal_secret] && params[:receiver_email] == APP_CONFIG[:paypal_email]
      order.update_attribute(:purchased_at, Time.now)
      #@cart.empty_all_items
    end
  end
end
