require File.dirname(__FILE__) + '/../test_helper'
require 'pages_controller'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase

  fixtures :users, :pages

  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = login_as 'quentin'
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  def test_should_get_index_without_login
    login_as nil
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_not_get_new_without_login
    login_as nil
    get :new
    assert_redirected_to login_path
  end

  def test_should_not_get_new_without_admin_login
    login_as 'aaron'
    get :new
    assert_redirected_to root_path
  end

  def test_should_create_page
    assert_difference('Page.count') do
      post :create, :page => { }
    end
    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_not_create_page_without_login
    login_as nil
    post :create, :page => { }
    assert_redirected_to login_path
  end

  def test_should_not_create_page_without_admin_login
    login_as 'aaron'
    post :create, :page => { }
    assert_redirected_to root_path
  end

  def test_should_show_page
    get :show, :id => pages(:one).id
    assert_response :success
  end

  def test_should_show_page_without_login
    login_as nil
    get :show, :id => pages(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pages(:one).id
    assert_response :success
  end

  def test_should_not_get_edit_without_login
    login_as nil
    get :edit, :id => pages(:one).id
    assert_redirected_to login_path
  end

  def test_should_not_get_edit_without_admin_login
    login_as 'aaron'
    get :edit, :id => pages(:one).id
    assert_redirected_to root_path
  end

  def test_should_update_page
    put :update, :id => pages(:one).id, :page => { }
    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_not_update_page_without_login
    login_as nil
    put :update, :id => pages(:one).id, :page => { }
    assert_redirected_to login_path
  end

  def test_should_not_update_page_without_admin_login
    login_as 'aaron'
    put :update, :id => pages(:one).id, :page => { }
    assert_redirected_to root_path
  end

  def test_should_destroy_page
    assert_difference('Page.count', -1) do
      delete :destroy, :id => pages(:one).id
    end
    assert_redirected_to pages_path
  end

  def test_should_not_destroy_page_without_login
    login_as nil
    delete :destroy, :id => pages(:one).id
    assert_redirected_to login_path
  end

  def test_should_not_destroy_page_without_admin_login
    login_as 'aaron'
    delete :destroy, :id => pages(:one).id
    assert_redirected_to root_path
  end
end
