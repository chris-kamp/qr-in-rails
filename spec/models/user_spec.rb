require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { User.destroy_all }
  context '.create' do
    let(:valid_attributes) do
      { email: 'test@test.com', password: 'Password1', username: 'test_user' }
    end
    it "doesn't permit duplicates on unique fields" do
      User.create! valid_attributes
      expect { User.create!(valid_attributes) }.to raise_error(
        ActiveRecord::RecordInvalid,
      )
    end
    it 'validates presence of email address' do
      email_missing = { password: 'password', username: 'test_user' }
      expect { User.create!(email_missing) }.to raise_error(
        ActiveRecord::RecordInvalid,
      )
    end
    it 'validates presence of username' do
      username_missing = { email: 'test@test.com', password: 'password' }
      expect { User.create!(username_missing) }.to raise_error(
        ActiveRecord::RecordInvalid,
      )
    end
    it 'validates presence of password' do
      password_missing = { email: 'test@test.com', username: 'test_user' }
      expect { User.create!(password_missing) }.to raise_error(
        ActiveRecord::RecordInvalid,
      )
    end
  end
end
