class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		# Log the user in, taken to the user's show page
  		log_in user
  		params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  		user.remember #This was different than the tutorial to get it to pass, before we were calling 'remember user' which was causing a cookies save again
  		redirect_to user
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end
