class User < ApplicationRecord

	has_many :posts
	has_many :followers, class_name: "Follow", foreign_key: "followee_id"
	#belongs_to :followee, class_name: "Follow", foreign_key: "follower_id", optional: true
	has_many :followees, class_name: "Follow", foreign_key: "follower_id"
	has_many :liked_post, class_name: "Like", foreign_key: "user_id"


	validates :email, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true
	validates :password_digest, length: {minimum: 1}
	validates :age, numericality: { only_integer: true }

	serialize :following, Array #serialize text "following" as arrays

	has_secure_password

	#complex function should be here!!!
	#===== custom define =====
	def get_feed_post(id)
		#followee_ids = Follow.where(follower_id: UID).pluck("followee_id")
		#Post.where(user_id: ids)
		
		# better approch (burden to database)
		#ids = Follow.where(follower_id: UID).pluck ('followee_id')
		#Post.where(user_id: ids).order('DESC created_at')

		display_posts = []
		c_user = User.find(id)
		c_user.followees.each do |follow|
	      user = User.find(follow.followee_id)
	        user.posts.each do |post|
	          display_posts.push(post)
	        end
	    end
	    display_posts.sort_by!{|post| post.created_at}
	    return display_posts

	end
	#===== end custom define =====
	
end
