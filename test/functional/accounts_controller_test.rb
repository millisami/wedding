require File.dirname(__FILE__) + '/../test_helper'
require 'accounts_controller'

# Re-raise errors caught by the controller.
class AccountsController; def rescue_action(e) raise e end; end

class AccountsControllerTest < Test::Unit::TestCase

  fixtures :users, :roles

  def setup
    @controller = AccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @admin = users(:quentin)
    @user  = users(:aaron)
  end

# edit

  def test_should_edit_with_login
    login_as @user.login
    get :edit
    assert_response :success
  end

  def test_should_not_edit_without_login
    login_as nil
    get :edit
    assert_redirected_to login_path
  end

# update (change_password)

  def test_should_update_with_login
    login_as @user.login
    put :update,
      :user_id => @user,
      :old_password => 'test',
      :password => 'new_password',
      :password_confirmation => 'new_password'
    assert_redirected_to user_path(@user)
  end

  def test_should_not_update_without_login
    login_as nil
    put :update,
      :user_id => @user,
      :old_password => 'test',
      :password => 'new_password',
      :password_confirmation => 'new_password'
    assert_redirected_to login_path
  end

  def test_should_not_update_with_incorrect_old_password
    login_as @user.login
    put :update,
      :user_id => @user,
      :old_password => 'wrong_password',
      :password => 'new_password',
      :password_confirmation => 'new_password'
    assert_response :success  # renders edit
  end

  def test_should_not_update_without_matching_confirmation
    login_as @user.login
    put :update,
      :user_id => @user,
      :old_password => 'test',
      :password => 'new_password',
      :password_confirmation => 'different_password'
    assert_response :success  # renders edit
  end

# show (activate)

  def test_should_activate_new_user
    login_as nil
    get :show, :id => 'test_activation_code'
    assert_redirected_to login_path
  end

  def test_should_not_activate_new_user_without_code
    login_as nil
    get :show
    assert_redirected_to new_user_path
  end

  def test_should_not_activate_new_user_with_invalid_code
    login_as nil
    get :show, :id => "invalid_activation_code"
    assert_redirected_to new_user_path
  end

  def test_should_not_activate_active_user
    login_as nil
    get :show, :id => "already_active_code"
    assert_redirected_to login_path
  end

end
