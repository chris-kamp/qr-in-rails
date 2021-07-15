class CreateStreets < ActiveRecord::Migration[6.1]
  def change
    create_table :streets do |t|
      t.string :description

      t.timestamps
    end
  end
end