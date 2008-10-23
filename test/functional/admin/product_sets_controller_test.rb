require 'test_helper'

class Admin::ProductSetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_product_sets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_product_set
    assert_difference('Admin::ProductSet.count') do
      post :create, :product_set => { }
    end

    assert_redirected_to product_set_path(assigns(:product_set))
  end

  def test_should_show_product_set
    get :show, :id => admin_product_sets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => admin_product_sets(:one).id
    assert_response :success
  end

  def test_should_update_product_set
    put :update, :id => admin_product_sets(:one).id, :product_set => { }
    assert_redirected_to product_set_path(assigns(:product_set))
  end

  def test_should_destroy_product_set
    assert_difference('Admin::ProductSet.count', -1) do
      delete :destroy, :id => admin_product_sets(:one).id
    end

    assert_redirected_to admin_product_sets_path
  end
end
