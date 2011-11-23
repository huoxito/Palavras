require 'test_helper'

class PalavrasControllerTest < ActionController::TestCase
  setup do
    @palavra = palavras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:palavras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create palavra" do
    assert_difference('Palavra.count') do
      post :create, palavra: @palavra.attributes
    end

    assert_redirected_to palavra_path(assigns(:palavra))
  end

  test "should show palavra" do
    get :show, id: @palavra.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @palavra.to_param
    assert_response :success
  end

  test "should update palavra" do
    put :update, id: @palavra.to_param, palavra: @palavra.attributes
    assert_redirected_to palavra_path(assigns(:palavra))
  end

  test "should destroy palavra" do
    assert_difference('Palavra.count', -1) do
      delete :destroy, id: @palavra.to_param
    end

    assert_redirected_to palavras_path
  end
end
