class User < ApplicationRecord

	has_many :posts
	has_many :followers, class_name: "Follow", foreign_key: "followee_id"
	#belongs_to :followee, class_name: "Follow", foreign_key: "follower_id", optional: true
	has_many :followees, class_name: "Follow", foreign_key: "follower_id"


	validates :email, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true
	validates :password_digest, length: {minimum: 1}
	validates :age, numericality: { only_integer: true }

	serialize :following, Array #serialize text "following" as arrays

	has_secure_password
	
end
