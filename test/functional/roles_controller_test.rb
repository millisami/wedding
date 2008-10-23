require File.dirname(__FILE__) + '/../test_helper'
require 'roles_controller'

# Re-raise errors caught by the controller.
class RolesController; def rescue_action(e) raise e end; end

class RolesControllerTest < Test::Unit::TestCase

  fixtures :users, :roles

  def setup
    @controller = RolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @admin = users(:quentin)
    @user  = users(:aaron)
  end

  def test_should_get_index_with_administrator_login
    login_as @admin.login
    get :index, { :user_id => @user }
    assert_response :success
  end

  def test_should_not_get_index_without_login
    login_as nil
    get :index, { :user_id => @user }
    assert_redirected_to login_path
  end

  def test_should_not_get_index_without_administrator_login
    login_as @user.login
    get :index, { :user_id => @user }
    assert_redirected_to root_path
  end

  def test_should_update_role_with_administrator_login
    login_as @admin.login
    put :update, 
      :id => roles(:admin).id, 
      :user_id => @user
    assert_redirected_to user_roles_path(@user)
  end

  def test_should_not_update_role_without_administrator_login
    login_as @user.login
    put :update, 
      :id => roles(:admin).id, 
      :user_id => @user
    assert_redirected_to root_path
  end

  def test_should_not_update_role_without_login
    login_as nil
    put :update, 
      :id => roles(:admin).id, 
      :user_id => @user
    assert_redirected_to login_path
  end

  def test_should_destroy_role_with_administrator_login
    login_as @admin.login
    delete :destroy, :id => roles(:admin).id, :user_id => users(:jakeb).id
    assert_redirected_to user_roles_path(users(:jakeb))
  end

  def test_should_not_destroy_role_without_administrator_login
    login_as @user.login
    delete :destroy, :id => roles(:admin).id, :user_id => @admin
    assert_redirected_to root_path
  end

  def test_should_not_destroy_role_without_login
    login_as nil
    delete :destroy, :id => roles(:admin).id, :user_id => @admin
    assert_redirected_to login_path
  end
end
