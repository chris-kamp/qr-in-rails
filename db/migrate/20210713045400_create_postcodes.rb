class CreatePostcodes < ActiveRecord::Migration[6.1]
  def change
    create_table :postcodes do |t|
      t.integer :code

      t.timestamps
    end
  end
end
