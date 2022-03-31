class AddUserImageToAllUsers < ActiveRecord::Migration[7.0]
  def change
    users = User.all
    users.each do |user|

      user_image = user.user_image.new
      playlist.save
    end
  end
end