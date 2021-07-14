class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.references :state, null: false, foreign_key: true
      t.references :street, null: false, foreign_key: true
      t.references :postcode, null: false, foreign_key: true
      t.references :suburb, null: false, foreign_key: true
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
