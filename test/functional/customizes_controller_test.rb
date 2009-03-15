require 'test_helper'

class CustomizesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
end
