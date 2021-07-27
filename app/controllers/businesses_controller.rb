class BusinessesController < ApplicationController
  before_action :set_business, except: [:index, :create, :search]

  # Rescue from 404 when record requested does not exist.
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  # GET /businesses
  def index
<<<<<<< Updated upstream
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
=======
    # Business records ordered by their created date
    businesses = Business.all.sort_by(&:weekly_checkin_count).reverse
    businesses.take(search_params[:limit].to_i) if search_params[:limit]

    render json: businesses,
           include: [
             {
               address: {
                 only: :street,
                 include: [
                   suburb: {
                     only: :name,
                   },
                   postcode: {
                     only: :code,
                   },
                   state: {
                     only: :name,
                   },
                 ],
               },
               category: {
                 only: :name,
               },
               reviews: {
                 only: :rating,
               },
             },
           ]
>>>>>>> Stashed changes
  end

  def search
    filters = JSON(search_params[:filter])
              .select { |_id, bool| bool }
              .keys.map { |id| id.to_s[(1..-1)].strip }
    results = Business.where('name ILIKE ?', "%#{search_params[:search]}%")
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
      render json: { errors: @business.errors }, status: :unprocessable_entity
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
