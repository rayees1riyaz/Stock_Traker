class User < ApplicationRecord
  has_secure_password

  has_many :stocks, dependent: :destroy

  validates :name, presence: true
  validates :shop_name, presence: true

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone,
            presence: true,
            uniqueness: true,
            format: { with: /\A\d{10}\z/, message: "must be exactly 10 digits" }

  validates :password,
            length: { minimum: 6 },
            if: -> { password.present? }
          
  validates :password_confirmation,
            presence: true,
            if: -> { password.present? }

  def generate_login_otp
    self.login_otp = rand(100_000..999_999).to_s
    self.login_otp_sent_at = Time.current
    save!(validate: false)
  end

  def otp_valid?(entered_otp)
    return false if login_otp.blank?
    return false if login_otp_sent_at < 10.minutes.ago

    login_otp == entered_otp
  end

  def clear_login_otp
    update_columns(
      login_otp: nil,
      login_otp_sent_at: nil
    )
  end

  def generate_password_reset_token
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!(validate: false)
  end

  def password_reset_token_valid?
    (reset_password_sent_at + 2.hours) > Time.current
  end

  def reset_password!(password_params)
    update(password_params.merge(reset_password_token: nil))
  end
end
