require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Test user", 
                                         email:"test@example.com",
                                         password: "111111",
                                         password_confirmation: "111111" 
                                         }
                                }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash[:errors]
    assert flash[:success]
  end
end
