require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "signup form works" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do 
    	post users_path, user: {name: "", email: "user@invalid", password: "foo", password_confirmation:"bar" }
    end
    assert_template 'users/new'
  end

  test "signup accepts a valid submission" do 
    get signup_path
    assert_response :success
    assert_difference "User.count", 1 do 
      post_via_redirect users_path, user: {name: "Example User", email:"user@example.com", password:"password", password_confirmation:"password"}
    end
    assert_template 'users/show'

    # test for the flash to be there
    assert_select "div.alert-success", 1
    assert flash.any?
    assert is_logged_in?
  end

  test "signup denies an invalid submission" do 
    get signup_path
    assert_response :success
    assert_no_difference "User.count" do 
      post_via_redirect users_path, user: {name: "Example User", email:"user@example", password:"pass", password_confirmation:"pass"}
    end
    assert_template 'users/new' #the submission fails and it returns to the submission page

    assert_select "div.alert-danger", "The form contains 2 errors"
    assert_select "ul#signup_errors", 1
  end
end
