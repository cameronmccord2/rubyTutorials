require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end

  test "unsuccessful edit" do
  	log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), user: {name: "", email: "foo@invalid", password:"bad", password_confirmation:"pass" }
    assert_template 'users/edit'
  end

  test "successful edit" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template 'users/edit'

  	name = "camm"
  	email = "valid@you.know"
  	patch user_path(@user), user: {name: name, email: email, password:'', password_confirmation:''}
  	assert_redirected_to @user
  	assert_not flash.empty?
  	assert_not flash[:success].blank?
  	@user.reload
  	assert_equal @user.name, name
  	assert_equal @user.email, email
  end

  test "friendly redirect after try to edit my profile when not logged in" do
  	get edit_user_path(@user)
  	log_in_as(@user)
  	assert_redirected_to edit_user_path(@user)
  	assert session[:forwarding_url].nil?
  end
end
