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
end
