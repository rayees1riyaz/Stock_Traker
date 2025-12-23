class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to stocks_path, notice: "Logged in successfully"
      UserMailer.login_alert(user).deliver_later
    else
      flash.now[:alert] = "Invalid email or password"
      flash.now[:email_error] = user.nil? ? "Email not found" : nil
      flash.now[:password_error] = user.present? ? "Incorrect password" : nil
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully!"
  end

  def forgot_password
  end

  def send_reset_link
    email = params[:email].to_s.downcase.strip
    
    if email.blank?
      redirect_to forgot_password_path, alert: "Email is required.", email: email
      return
    end

    user = User.find_by(email: email)
    
    if user
      user.generate_password_reset_token
      UserMailer.reset_password_email(user).deliver_later
      
      redirect_path = current_user ? users_path : login_path
      redirect_to redirect_path, notice: "If an account exists with that email, we have sent a reset link to it."
    else
      redirect_to forgot_password_path, alert: "Email not found.", email: email
    end
  end

  def edit_password_reset
    @user = User.find_by(reset_password_token: params[:token])
    @token_invalid = @user.nil? || !@user.password_reset_token_valid?
  end

  def update_password_reset
    @user = User.find_by(reset_password_token: params[:token])
    
    if @user.nil? || !@user.password_reset_token_valid?
      @token_invalid = true
      render :edit_password_reset, status: :unprocessable_entity
      return
    end

    if @user.reset_password!(password_reset_params)
      if current_user
        session[:user_id] = @user.id
        redirect_to stocks_path, notice: "Password reset successfully!"
      else
        redirect_to login_path, notice: "Password reset successfully! Please login with your new password."
      end
    else
      render :edit_password_reset, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
