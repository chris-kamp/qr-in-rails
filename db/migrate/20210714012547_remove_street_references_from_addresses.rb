class RemoveStreetReferencesFromAddresses < ActiveRecord::Migration[6.1]
  def change
    change_table :addresses do |t|
      t.remove_references :street
    end
  end
end
