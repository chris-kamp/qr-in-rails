class AddListingImgSrcToBusinesses < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :listing_img_src, :string
  end
end
