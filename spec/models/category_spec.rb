require 'rails_helper'

RSpec.describe Category, type: :model do
  before(:all) { Category.destroy_all }

  context '.create' do
    let(:valid_attributes) { { name: 'foo' } }
    it "doesn't permit duplicates on unique fields" do
      Category.create! valid_attributes
      expect { Category.create!(valid_attributes) }.to raise_error(
        ActiveRecord::RecordInvalid,
      )
    end
    it 'validates the presence of a name' do
      expect {
        Category.create!(valid_attributes.except(:name))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
