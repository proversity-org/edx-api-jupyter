require 'test_helper'

class NoteyNoteysControllerTest < ActionController::TestCase
  setup do
    @notey_notey = notey_noteys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notey_noteys)
  end

  test "should create notey_notey" do
    assert_difference('NoteyNotey.count') do
      post :create, notey_notey: {  }
    end

    assert_response 201
  end

  test "should show notey_notey" do
    get :show, id: @notey_notey
    assert_response :success
  end

  test "should update notey_notey" do
    put :update, id: @notey_notey, notey_notey: {  }
    assert_response 204
  end

  test "should destroy notey_notey" do
    assert_difference('NoteyNotey.count', -1) do
      delete :destroy, id: @notey_notey
    end

    assert_response 204
  end
end
