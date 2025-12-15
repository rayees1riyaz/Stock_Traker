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
end
