class Post < ApplicationRecord
  belongs_to :user
  has_many :likes

  #can use pluck
  #User.where(:id => self.likes.pluck('user_id')).pluck('name')
  #pluck not creating new obj = less allocation(optimization can be look in command line)
  # or use include
  #self.likes.joins(:user).pluck('name') # ***1-1 to user***
  def get_liked_user
    return self.likes.joins(:user).pluck('name');
  end

end
