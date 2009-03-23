class ConfirmationsController < ApplicationController
  def index
    @confirmations = Confirmation.find(:all)
  end
end
