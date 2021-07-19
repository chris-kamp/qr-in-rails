class FixCheckinsKeyColumnNameInReview < ActiveRecord::Migration[6.1]
  def change
    change_table :reviews do |t|
      t.rename :checkins_id, :checkin_id
    end
  end
end
