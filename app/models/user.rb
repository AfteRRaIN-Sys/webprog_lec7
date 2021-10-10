class User < ApplicationRecord

	has_many :posts

	validates :email, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true
	validates :password_digest, length: {minimum: 1}
	validates :age, numericality: { only_integer: true }

	serialize :following, Array #serialize text "following" as arrays

	has_secure_password
	
end
