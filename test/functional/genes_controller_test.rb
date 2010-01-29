require 'test_helper'

class GenesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:genes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gene" do
    assert_difference('Gene.count') do
      post :create, :gene => { }
    end

    assert_redirected_to gene_path(assigns(:gene))
  end

  test "should show gene" do
    get :show, :id => genes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => genes(:one).to_param
    assert_response :success
  end

  test "should update gene" do
    put :update, :id => genes(:one).to_param, :gene => { }
    assert_redirected_to gene_path(assigns(:gene))
  end

  test "should destroy gene" do
    assert_difference('Gene.count', -1) do
      delete :destroy, :id => genes(:one).to_param
    end

    assert_redirected_to genes_path
  end
end
