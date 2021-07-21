require 'rails_helper'

RSpec.describe Business, type: :model do
  before(:all) do
    User.destroy_all
    Address.destroy_all
    Business.destroy_all
    Category.destroy_all
    @user     = User.create!(email: "test@test.com", password: "Secrets1", username: "foobar", public: true, bio: "Hi, I'm a user")
    @category = Category.create!(name: "bar")
    @address  = Address.new(
      street: '123 foo',
      suburb: Suburb.find_or_create_by(name: 'foo'),
      postcode: Postcode.find_or_create_by(code: 1234),
      state: State.find_or_create_by(name: 'ABC')
    )
  end

  context ".create" do
    let(:valid_attributes) {
      {
        user_id: @user.id,
        category_id: @category.id,
        name: 'foo',
        description: 'foo',
        address: @address
      }
    }
    it "doesn't permit duplicates on unique fields" do
      Business.create! valid_attributes
      expect {Business.create!(valid_attributes)}.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "validates the presence of a name" do
      expect {Business.create!(valid_attributes.except(:name))}.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "requires an address to exist" do
      expect {Business.create!(valid_attributes.except(:address))}.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "requires a user association" do
      expect {Business.create!(valid_attributes.except(:user_id))}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
