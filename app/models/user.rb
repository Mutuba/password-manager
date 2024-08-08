class User < ApplicationRecord
  has_secure_password

  validates :password_digest, :email, presence: true
  has_many :vaults
end
