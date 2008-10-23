class MessagesController < ApplicationController
  before_filter :login_required

  def new
  end

  def create
    @subject = params[:subject]
    @body    = params[:body]
    if UserMailer.deliver_message_to_admin(@subject, @body)
      flash[:notice] = 'Your message was sent.'
      redirect_to root_path
    else
      # I don't think that this is EVER done
      # If you read this and know how to determine whether
      # there was a problem, please contact me.  ThanX
      flash[:error] = 'There was a problem sending your message.'
      render :action => 'new'
    end 
  end
end
