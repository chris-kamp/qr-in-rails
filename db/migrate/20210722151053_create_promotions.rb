class CreatePromotions < ActiveRecord::Migration[6.1]
  def change
    create_table :promotions do |t|
      t.references :business
      t.string :description
      t.datetime :end_date

      t.timestamps
    end
  end
end
