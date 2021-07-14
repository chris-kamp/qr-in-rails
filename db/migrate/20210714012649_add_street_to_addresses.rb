class AddStreetToAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :street, :string
  end
end
