class ConfirmationsController < ApplicationController
  layout 'site'
  def index
    respond_to do |format|
        format.html
    end
  end
end
