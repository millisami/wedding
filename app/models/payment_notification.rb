class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_purchased

  private
  def mark_order_as_purchased
    if status == "Completed"
      order.update_attribute(:purchased_at, Time.now)
      @cart.empty_all_items
    end
  end
end
