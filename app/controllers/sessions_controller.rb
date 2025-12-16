class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      user.generate_login_otp
      UserMailer.login_security_code(user).deliver_later

      session[:pending_user_id] = user.id
      redirect_to verify_login_path, notice: "Security code sent to your email"
    else
      flash.now[:alert] = "Invalid email or password"
      flash.now[:email_error] = user.nil? ? "Email not found" : nil
      flash.now[:password_error] = user.present? ? "Incorrect password" : nil

      render :new, status: :unprocessable_entity
    end
  end

  def verify
  end

  def confirm
    user = User.find_by(id: session[:pending_user_id])

    if user&.otp_valid?(params[:otp])
      user.clear_login_otp
      session.delete(:pending_user_id)

      session[:user_id] = user.id
       UserMailer.login_alert(user).deliver_later
      redirect_to stocks_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid or expired security code"
      render :verify, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully!"
  end
end
