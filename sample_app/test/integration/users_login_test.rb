require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
		puts "\n\n\n\n"
	end

  test "should fail and display error for invalid login" do
    get login_path
    assert_response :success
    assert_template 'sessions/new'

    post login_path, session: {email: "", password: ""} #causes a fail
    assert_template 'sessions/new'
    assert_not flash.empty?

    get root_path
    assert flash.empty? # the flash shouldn't persist longer than 1 route change
  end

  test "should login successfully and then logout" do
  	get login_path
  	assert_response :success
  	assert_template 'sessions/new'

  	post login_path, session: {email: @user.email, password: "password"}
  	assert_redirected_to @user
  	follow_redirect!
  	assert is_logged_in?
  	assert_template 'users/show'
  	assert_select "a#logout", 1
  	assert_select "a#profile", 1
  	assert_select "a#login", 0
  	assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate a user clicking logout in another window after it has already been done in this window
    delete logout_path

    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end
end
