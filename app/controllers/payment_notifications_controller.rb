class PaymentNotificationsController < ApplicationController
  def create
    @payment_notification = PaymentNotification.new(params[:payment_notification])
    if @payment_notification.save
      flash[:notice] = "Successfully created payment notification."
      redirect_to payment_notifications_url
    else
      render :action => 'new'
    end
  end
end
