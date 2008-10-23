require File.dirname(__FILE__) + '/../test_helper'
require 'passwords_controller'

# Re-raise errors caught by the controller.
class PasswordsController; def rescue_action(e) raise e end; end

class PasswordsControllerTest < Test::Unit::TestCase

  fixtures :users, :roles

  def setup
    @controller = PasswordsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @admin = users(:quentin)
    @user  = users(:aaron)
    login_as nil
  end

# new (forgot_password)

  def test_should_not_prompt_for_email_address_with_login
    login_as @user.login
    get :new
    assert_redirected_to root_path
  end

  def test_should_prompt_for_email_address_without_login
    get :new
    assert_response :success
  end

# create

  def test_should_not_create_link_with_incorrect_email
    post :create, :email => "fake@email.com"
    assert_response :success
  end

  def test_should_create_link_with_correct_email
    post :create, :email => @user.email
    assert_redirected_to login_path
  end

  def test_should_not_create_link_without_activated_user
    post :create, :email => users(:nouveau).email
    assert_response :success
  end

# edit (reset_password)

  def test_should_render_new_without_id
    get :edit
    assert_response :success
  end

  def test_should_prompt_for_new_password_with_correct_id
    get :edit, :id => 'test_reset_code'
    assert_response :success
  end

  def test_should_not_prompt_for_new_password_with_incorrect_id
    get :edit, :id => "fakeid"
    assert_redirected_to new_user_path
  end

# update

  def test_should_render_new_without_id
    put :update, :id => ""
    assert_response :success
  end

  def test_should_render_new_with_incorrect_id_and_no_password
    put :update, :id => "fakeid"
    assert_response :success
  end

  def test_should_render_new_with_correct_id_and_no_password
    put :update, :id => "test_reset_code"
    assert_response :success
  end

  def test_should_render_new_with_incorrect_id_and_blank_password
    put :update, :id => "fakeid", :password => "", :password_confirmation => ""
    assert_response :success
  end

  def test_should_render_new_with_correct_id_and_blank_password
    put :update, :id => "test_reset_code", :password => "", :password_confirmation => ""
    assert_response :success
  end

  def test_should_render_new_with_correct_id_and_password
    put :update, :id => "test_reset_code", 
      :password => "new_password", 
      :password_confirmation => "new_password"
    assert_redirected_to login_path
  end

  def test_should_render_edit_with_correct_id_and_mismatched_passwords
    put :update, :id => "test_reset_code", 
      :password => "new_password", 
      :password_confirmation => "different_password"
    assert_response :success
  end

end
