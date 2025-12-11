class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      flash.now[:email_error] = user.nil? ? "Email not found" : nil
      flash.now[:password_error] = (user && !user.authenticate(params[:password])) ? "Incorrect password" : nil

      render :new, status: :unprocessable_entity
    end
  end

def destroy
  session[:user_id] = nil
  redirect_to login_path, notice: "Logged out successfully!"
end
end
