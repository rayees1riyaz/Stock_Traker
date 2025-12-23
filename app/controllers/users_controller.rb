class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = [current_user]
  end

  def edit
  end

  def notifications
  end

  def appearance
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "Settings updated successfully"
    else
      if request.referer&.include?("notifications")
        render :notifications, status: :unprocessable_entity
      elsif request.referer&.include?("appearance")
        render :appearance, status: :unprocessable_entity
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Account deleted successfully"
  end

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
      :shop_name,
      :notify_account_activity,
      :notify_weekly_summary,
      :notify_new_stock,
      :notify_low_stock,
      :notify_price_updates,
      :theme,
      :density
    )
  end

  def set_user
    @user = current_user
  end
end
