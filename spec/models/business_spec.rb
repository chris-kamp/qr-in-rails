require 'rails_helper'

RSpec.describe Business, type: :model do
  before(:all) do
    User.destroy_all
    Address.destroy_all
    Business.destroy_all
    Category.destroy_all
    @user =
      User.create!(
        email: 'test@test.com',
        password: 'Secrets1',
        username: 'foobar',
        public: true,
        bio: "Hi, I'm a user",
      )
    @user2 =
      User.create!(
        email: 'test2@test.com',
        password: 'Secrets2',
        username: 'foobar2',
        public: true,
        bio: "Hi, I'm a user",
      )
    @category = Category.create!(name: 'bar')
    @category2 = Category.create!(name: 'foo')
    @address =
      Address.new(
        street: '123 foo',
        suburb: Suburb.find_or_create_by(name: 'foo'),
        postcode: Postcode.find_or_create_by(code: 1234),
        state: State.find_or_create_by(name: 'ABC'),
      )
    @address2 =
      Address.new(
        street: '123 foobar',
        suburb: Suburb.find_or_create_by(name: 'foobar'),
        postcode: Postcode.find_or_create_by(code: 1235),
        state: State.find_or_create_by(name: 'CDE'),
      )
  end

  let(:valid_attributes) do
    {
      user_id: @user.id,
      category_id: @category.id,
      name: 'foo',
      description: 'foo',
      address: @address,
    }
  end
  
  context '.create' do
    let(:duplicate_name) do
      {
        user_id: @user2.id,
        category_id: @category.id,
        name: 'foo',
        description: 'bar',
        address: @address2,
      }
    end
    it "validates uniqueness of name" do
      Business.create! valid_attributes
      expect { Business.create!(duplicate_name) }.to raise_error(
        ActiveRecord::RecordInvalid,
      )
    end
    it 'validates the presence of a name' do
      expect {
        Business.create!(valid_attributes.except(:name))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'validates the presence of a description' do
      expect {
        Business.create!(valid_attributes.except(:description))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'requires an address to exist' do
      expect {
        Business.create!(valid_attributes.except(:address))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'requires a user association' do
      expect {
        Business.create!(valid_attributes.except(:user_id))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'requires a category association' do
      expect {
        Business.create!(valid_attributes.except(:category_id))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  context ".checkins" do
    it "orders by creation time (descending)" do
      business = Business.create! valid_attributes
      business.checkins.create!(user: @user2, review: Review.create(rating: 1))
      business.checkins.create!(user: @user2, review: Review.create(rating: 2))
      business.reload
      expect(business.checkins[0].review.rating).to eq 2
    end
  end

  context ".filter_by_category" do
    let(:additional_valid_attributes) do
      {
        user_id: @user2.id,
        category_id: @category2.id,
        name: 'biz',
        description: 'bar',
        address: @address2,
      }
    end
    it "retrieves a collection of businesses with a given category_id" do
      Business.create! valid_attributes
      business2 = Business.create!(additional_valid_attributes)
      expect(Business.filter_by_category(@category2)[0]).to eq business2
    end
  end

  context ".active_promotions" do
    it "returns a collection" do
      business = Business.create! valid_attributes
      expect(business.active_promotions.class.name).to eq "ActiveRecord::AssociationRelation"
    end
  end
end
