require 'test_helper'

class OrderLinesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:order_lines)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_order_line
    assert_difference('OrderLine.count') do
      post :create, :order_line => { }
    end

    assert_redirected_to order_line_path(assigns(:order_line))
  end

  def test_should_show_order_line
    get :show, :id => order_lines(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => order_lines(:one).id
    assert_response :success
  end

  def test_should_update_order_line
    put :update, :id => order_lines(:one).id, :order_line => { }
    assert_redirected_to order_line_path(assigns(:order_line))
  end

  def test_should_destroy_order_line
    assert_difference('OrderLine.count', -1) do
      delete :destroy, :id => order_lines(:one).id
    end

    assert_redirected_to order_lines_path
  end
end
