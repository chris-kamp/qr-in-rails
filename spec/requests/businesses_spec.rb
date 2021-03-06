require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/businesses', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Business. As you add validations to Business, be sure to
  # adjust the attributes here as well.

  before(:all) do
    User.destroy_all
    Address.destroy_all
    Business.destroy_all
    Category.destroy_all
    @email = 'test@test.com'
    @email2 = 'test2@test2.com'
    @user =
      User.create!(
        email: @email,
        password: 'Secrets1',
        username: 'foobar',
        public: true,
        bio: "Hi, I'm a user",
      )
    @non_owner =
      User.create!(
        email: @email2,
        password: 'Secrets2',
        username: 'ahacker',
        public: true,
        bio: "I'm not the business owner!",
      )
    @category = Category.create!(name: 'bar')
    @address =
      Address.new(
        street: '123 foo',
        suburb: Suburb.find_or_create_by(name: 'foo'),
        postcode: Postcode.find_or_create_by(code: 1234),
        state: State.find_or_create_by(name: 'ABC'),
      )
    @payload = { email: @email, exp: Time.now.to_i + 3600 }
    @token = JWT.encode(@payload, ENV['JWT_KEY'], 'HS512')
    @expired_payload = { email: @email, exp: Time.now.to_i - 3600 }
    @expired_token = JWT.encode(@expired_payload, ENV['JWT_KEY'], 'HS512')
    @non_owner_payload = { email: @email2, exp: Time.now.to_i + 3600 }
    @non_owner_token = JWT.encode(@non_owner_payload, ENV['JWT_KEY'], 'HS512')
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

  let(:invalid_attributes) do
    { user_id: nil, category_id: nil, name: nil, description: nil }
  end

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # BusinessesController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) { { Authorization: "Bearer #{@token}" } }
  let(:expired_token_headers) do
    { Authorization: "Bearer #{@expired_token}" }
  end
  let(:non_owner_headers) { { Authorization: "Bearer #{@non_owner_token}" } }

  describe 'GET /index' do
    it 'renders a successful response' do
      Business.create! valid_attributes
      get businesses_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
    it "renders a JSON response with a collection of businesses" do
      Business.create! valid_attributes
      get businesses_url, headers: valid_headers, as: :json
      expect(response.content_type).to match(
        a_string_including('application/json'),
      )
      expect(response.parsed_body[0]['name']).to eq('foo')
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      business = Business.create! valid_attributes
      get business_url(business), as: :json
      expect(response).to be_successful
    end
    it 'renders a JSON response with the business' do
      business = Business.create! valid_attributes
      get business_url(business), as: :json
      expect(response.content_type).to match(
        a_string_including('application/json'),
      )
      expect(response.parsed_body['name']).to eq('foo')
    end
  end

  describe 'POST /create' do
    context 'with valid parameters and headers' do
      it 'creates a new Business' do
        expect {
          post businesses_url,
               params: {
                 business: valid_attributes,
               },
               headers: valid_headers,
               as: :json
        }.to change(Business, :count).by(1)
      end

      it 'renders a JSON response with the new business' do
        post businesses_url,
             params: {
               business: valid_attributes,
             },
             headers: valid_headers,
             as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(
          a_string_including('application/json'),
        )
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Business' do
        expect {
          post businesses_url,
               params: {
                 business: invalid_attributes,
               },
               headers: valid_headers,
               as: :json
        }.to change(Business, :count).by(0)
      end

      it 'renders a JSON response with errors for the new business' do
        post businesses_url,
             params: {
               business: invalid_attributes,
             },
             headers: valid_headers,
             as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(
          a_string_including('application/json'),
        )
      end
    end

    context 'without auth token' do
      it 'does not create a new Business' do
        expect {
          post businesses_url, params: { business: valid_attributes }, as: :json
        }.to change(Business, :count).by(0)
      end
      it 'responds with unauthorized status' do
        post businesses_url, params: { business: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired auth token' do
      it 'does not create a new Business' do
        expect {
          post businesses_url,
               params: {
                 business: valid_attributes,
               },
               headers: expired_token_headers,
               as: :json
        }.to change(Business, :count).by(0)
      end
      it 'responds with unauthorized status' do
        post businesses_url,
             params: {
               business: invalid_attributes,
             },
             headers: expired_token_headers,
             as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /update' do
    let(:valid_new_attributes) do
      {
        user_id: @user.id,
        category_id: @category.id,
        name: 'bar',
        description: 'bar',
        address: @address,
      }
    end
    context 'with valid parameters and headers' do
      it 'updates the requested business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              headers: valid_headers,
              as: :json
        business.reload
        expect(business.name).to eq('bar')
      end

      it 'renders a JSON response with the business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              headers: valid_headers,
              as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(
          a_string_including('application/json'),
        )
        expect(response.parsed_body['description']).to eq('bar')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: invalid_attributes,
              },
              headers: valid_headers,
              as: :json
        business.reload
        expect(business.name).to eq('foo')
      end
      it 'renders a JSON response with errors for the business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: invalid_attributes,
              },
              headers: valid_headers,
              as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(
          a_string_including('application/json'),
        )
      end
    end

    context 'without auth token' do
      it 'does not update the business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              as: :json
        business.reload
        expect(business.name).to eq('foo')
      end
      it 'responds with unauthorized status' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired auth token' do
      it 'does not update the business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              headers: expired_token_headers,
              as: :json
        business.reload
        expect(business.name).to eq('foo')
      end
      it 'responds with unauthorized status' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              headers: expired_token_headers,
              as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'where user is not the business owner' do
      it 'does not update the business' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              headers: non_owner_headers,
              as: :json
        business.reload
        expect(business.name).to eq('foo')
      end
      it 'responds with forbidden status' do
        business = Business.create! valid_attributes
        patch business_url(business),
              params: {
                business: valid_new_attributes,
              },
              headers: non_owner_headers,
              as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with valid headers' do
      it 'destroys the requested business' do
        business = Business.create! valid_attributes
        expect {
          delete business_url(business), headers: valid_headers, as: :json
        }.to change(Business, :count).by(-1)
      end
    end
    context 'without auth token' do
      it 'does not destroy the requested business' do
        business = Business.create! valid_attributes
        expect { delete business_url(business), as: :json }.to change(
          Business,
          :count,
        ).by(0)
      end
      it 'responds with unauthorized status' do
        business = Business.create! valid_attributes
        delete business_url(business), as: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'does not destroy the requested business' do
        business = Business.create! valid_attributes
        expect { delete business_url(business), as: :json }.to change(
          Business,
          :count,
        ).by(0)
      end
    end

    context 'with expired auth token' do
      it 'does not destroy the requested business' do
        business = Business.create! valid_attributes
        expect {
          delete business_url(business),
                 headers: expired_token_headers,
                 as: :json
        }.to change(Business, :count).by(0)
      end
      it 'responds with unauthorized status' do
        business = Business.create! valid_attributes
        delete business_url(business), headers: expired_token_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'where user is not the business owner' do
      it 'does not destroy the requested business' do
        business = Business.create! valid_attributes
        expect {
          delete business_url(business), headers: non_owner_headers, as: :json
        }.to change(Business, :count).by(0)
      end
      it 'responds with forbidden status' do
        business = Business.create! valid_attributes

        delete business_url(business), headers: non_owner_headers, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
