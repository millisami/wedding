require 'test_helper'

class ProductSetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:product_sets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_product_set
    assert_difference('ProductSet.count') do
      post :create, :product_set => { }
    end

    assert_redirected_to product_set_path(assigns(:product_set))
  end

  def test_should_show_product_set
    get :show, :id => product_sets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => product_sets(:one).id
    assert_response :success
  end

  def test_should_update_product_set
    put :update, :id => product_sets(:one).id, :product_set => { }
    assert_redirected_to product_set_path(assigns(:product_set))
  end

  def test_should_destroy_product_set
    assert_difference('ProductSet.count', -1) do
      delete :destroy, :id => product_sets(:one).id
    end

    assert_redirected_to product_sets_path
  end
end
