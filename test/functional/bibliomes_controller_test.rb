require 'test_helper'

class BibliomesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bibliomes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bibliome" do
    assert_difference('Bibliome.count') do
      post :create, :bibliome => { }
    end

    assert_redirected_to bibliome_path(assigns(:bibliome))
  end

  test "should show bibliome" do
    get :show, :id => bibliomes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bibliomes(:one).to_param
    assert_response :success
  end

  test "should update bibliome" do
    put :update, :id => bibliomes(:one).to_param, :bibliome => { }
    assert_redirected_to bibliome_path(assigns(:bibliome))
  end

  test "should destroy bibliome" do
    assert_difference('Bibliome.count', -1) do
      delete :destroy, :id => bibliomes(:one).to_param
    end

    assert_redirected_to bibliomes_path
  end
end
