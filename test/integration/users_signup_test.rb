require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", 
                                         email:"user@invalid",
                                         password: "111111",
                                         password_confirmation: "222222" 
                                         }
                                }
    end
    assert_template 'users/new'
  end

  test "valid signup with activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example user", 
                                         email:"test@example.com",
                                         password: "password",
                                         password_confirmation: "password" 
                                         }
                                }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # login try
    log_in_as(user)
    assert_not is_logged_in?

    # invalid token
    get edit_account_activation_path("invalid token", email:user.email)
    assert_not is_logged_in?

    #valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong@email.com")
    assert_not is_logged_in?

    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?

    # assert_template 'users/show'
    # assert_not flash[:errors]
    # assert flash[:success]
    # assert is_logged_in?
  end
end
