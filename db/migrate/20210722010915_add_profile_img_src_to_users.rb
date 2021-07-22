class AddProfileImgSrcToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :profile_img_src, :string
  end
end
