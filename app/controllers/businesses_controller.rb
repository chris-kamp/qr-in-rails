class BusinessesController < ApplicationController
  before_action :set_business, except: [:index, :create, :search]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def index
    render json: Business.order(created_at: :desc), include: [{
      address: {
        only: :street,
        include: [
          suburb: { only: :name },
          postcode: { only: :code },
          state: { only: :name }
        ]
      },
      category: { only: :name },
      reviews: { only: :rating }
    }]
  end

  def search
    filters = JSON(search_params[:filter])
              .select { |_id, bool| bool }
              .keys.map { |id| id.to_s[1].to_i }

    results = Business.where('name LIKE ?', "%#{search_params[:search]}%")
    results = results.filter_by_category(filters) if filters.length > 0

    render json: results, include: [{
      address: {
        only: :street,
        include: [
          suburb: { only: :name },
          postcode: { only: :code },
          state: { only: :name }
        ]
      },
      category: { only: :name },
      reviews: {},
      checkins: {
        include: [
          user: { only: :username },
          review: { only: [:rating, :content] }
        ]
      }
    }]
  end

  def show
    render json: @business, include: [{
      address: {
        only: :street,
        include: [
          suburb: { only: :name },
          postcode: { only: :code },
          state: { only: :name }
        ]
      },
      category: { only: :name },
      reviews: {},
      checkins: {
        include: [
          user: { only: :username },
          review: { only: [:rating, :content] }
        ]
      }
    }]
  end

  def create
    # Create a Busines with the business_params function as attributes.
    business = Business.new(business_params)

    # If the business was created successfully, return the business, otherwise a 422 unprocessable entity.
    if business.save
      render json: business, include: [:address], status: :created
    else
      render json: { errors: business.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @business.update(business_params)
      render json: @business
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO: Replace with a soft-delete, and a restore option?
    if @business.destroy
      render status: :no_content
    else
      render json: { errors: @business.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    # Permit only the attributes expected for Business.
    business = params.require(:business).permit(:category_id, :user_id, :name, :description, address: [:street, :suburb, :postcode, :state])

    # Change the [:address] object into the Address model, with Suburb, Postcode, State associations
    # using find_or_create_by to limit duplicate data.
    business[:address] = Address.new(
      street: business[:address][:street],
      suburb: Suburb.find_or_create_by(name: business[:address][:suburb]),
      postcode: Postcode.find_or_create_by(code: business[:address][:postcode]),
      state: State.find_or_create_by(name: business[:address][:state])
    ) unless business[:address].nil?

    return business
  end

  def search_params
    params.permit(:search, :filter)
  end
end
