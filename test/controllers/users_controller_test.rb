require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @user2 = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit without logging in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update without logging in" do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit other user" do
    log_in_as(@user2)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update other user" do
    log_in_as(@user2)
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow admin status change by updating" do
    log_in_as(@user2)
    assert_not @user2.admin
    patch user_path(@user2), params: {
      user: {
        name: @user2.name,
        email:@user2.email,
        password: "password",
        password_confirmation: "password",
        admin: true
      }
    }
    assert_not @user2.reload.admin?
  end

  test "should redirect delete if not login" do 
    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_redirected_to login_url
  end

  test "should not none-admin user delete account" do 
    log_in_as(@user2)
    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_redirected_to root_url 
  end

  test "should admin user delete account" do 
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@user2)
    end
  end
end
