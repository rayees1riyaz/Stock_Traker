class UsersController < ApplicationController
  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.generate_login_otp
      UserMailer.signup_security_code(@user).deliver_later

      session[:pending_user_id] = @user.id
      redirect_to verify_signup_path, notice: "Verification code sent to your email"
    else
      render :signup, status: :unprocessable_entity
    end
  end

  def verify_signup
  end

  def confirm_signup
    user = User.find_by(id: session[:pending_user_id])

    if user&.otp_valid?(params[:otp])
      user.clear_login_otp
      session.delete(:pending_user_id)

      session[:user_id] = user.id
      UserMailer.signup_email(user).deliver_later

      redirect_to stocks_path, notice: "Signup completed successfully"
    else
      flash.now[:alert] = "Invalid or expired verification code"
      render :verify_signup, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :phone,
      :password,
      :password_confirmation,
      :shop_name
    )
  end
end
