class AddFollowingToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :following, :text
    remove_column :users, :followers, :text
  end
end
