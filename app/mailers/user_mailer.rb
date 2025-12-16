class UserMailer < ApplicationMailer
  default from: "no-reply@stocktraker.com"

  def signup_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to Stock Traker"
    )
  end

  def login_security_code(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Your Stock Traker security code"
    )
  end

  def signup_security_code(user)
  @user = user
  mail(
    to: @user.email,
    subject: "Verify your Stock Traker account"
  )
end

def login_alert(user)
    @user = user
    mail(
      to: @user.email,
      subject: "New login to your Stock Traker account"
    )
  end
end
