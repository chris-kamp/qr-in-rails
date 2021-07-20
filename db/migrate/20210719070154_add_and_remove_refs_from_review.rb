class AddAndRemoveRefsFromReview < ActiveRecord::Migration[6.1]
  def change
    change_table :reviews do |t|
      t.remove_references :user
      t.remove_references :business
      add_reference :reviews, :checkins, foreign_key: true
    end
  end
end
