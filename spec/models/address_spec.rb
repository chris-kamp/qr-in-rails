require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:all) do
    User.destroy_all
    Business.destroy_all
    Category.destroy_all
    Address.destroy_all
    Suburb.destroy_all
    Postcode.destroy_all
    State.destroy_all

    @user =
      User.create!(
        email: 'test@test.com',
        password: 'Secrets1',
        username: 'foobar',
        public: true,
        bio: "Hi, I'm a user",
      )
    @category = Category.create!(name: 'bar')
    @business =
      Business.new(
        category_id: @category.id,
        user_id: @user.id,
        name: 'foo',
        description: 'foo',
      )
  end
  context '.create' do
    let(:valid_attributes) do
      {
        business: @business,
        street: '123 Foo St',
        suburb: Suburb.find_or_create_by(name: 'foo'),
        postcode: Postcode.find_or_create_by(code: 1234),
        state: State.find_or_create_by(name: 'ABC'),
      }
    end
    it 'references existing associations with matching a Suburb, Postcode, or State' do
      Address.create! valid_attributes
      expect(Address.count).to eq(1)
      expect(Suburb.count).to eq(1)
      expect(Postcode.count).to eq(1)
      expect(State.count).to eq(1)

      Address.create! valid_attributes
      expect(Address.count).to eq(2)
      expect(Suburb.count).to eq(1)
      expect(Postcode.count).to eq(1)
      expect(State.count).to eq(1)
    end
  end
end
