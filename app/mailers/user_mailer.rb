class UserMailer < ApplicationMailer
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end

  def forgot_password(user)
    setup_email(user)
    @subject    += 'You have requested to change your password'
    @body[:url]  = "http://#{SITE_URL}/reset_password/#{user.password_reset_code}"
  end

  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset.'
  end

  def message_to_admin(subject,body)
    @admin = User.find_by_login('admin')
    @recipients  = @admin.email
    @from        = @admin.email
    @subject     = "Handmade Wedding Cards"
    @sent_on     = Time.now
    @subject    += subject
    @body[:body]  = body
  end

protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "info@handmadeweddingcards.com"
    @subject     = "Handmade Wedding Cards - "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
