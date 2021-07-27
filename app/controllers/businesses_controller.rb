class BusinessesController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :set_business, except: %i[index create search]
  before_action :authenticate, except: %i[index search show]

  # Rescue from 404 when record requested does not exist.
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  # GET /businesses
  def index
    # Business records ordered by their popularity
    businesses = Business.all.sort_by(&:weekly_checkin_count).reverse
    # Limit the amount of businesses returned to the :limit parameter
    businesses = businesses.take(search_params[:limit].to_i) if search_params[:limit]
    # Render the businesses, include related associations and the attributes
    #   required from them
    render json: businesses,
           include: [
             {
               address: {
                 only: :street,
                 include: [
                   suburb: {
                     only: :name
                   },
                   postcode: {
                     only: :code
                   },
                   state: {
                     only: :name
                   }
                 ]
               },
               category: {
                 only: :name
               },
               reviews: {
                 only: :rating
               }
             }
           ]
  end

  def search
    filters =
      JSON(search_params[:filter])
      .select { |_id, bool| bool }
      .keys
      .map { |id| id.to_s[(1..-1)].strip }
    results =
      Business.where(
        'name ILIKE :search OR description ILIKE :search',
        search: "%#{search_params[:search]}%"
      )

    results = results.filter_by_category(filters) unless filters.empty?

    render json: results,
           include: [
             {
               address: {
                 only: :street,
                 include: [
                   suburb: {
                     only: :name
                   },
                   postcode: {
                     only: :code
                   },
                   state: {
                     only: :name
                   }
                 ]
               },
               category: {
                 only: :name
               },
               reviews: {},
               checkins: {
                 include: [
                   user: {
                     only: :username
                   },
                   review: {
                     only: %i[rating content]
                   }
                 ]
               }
             }
           ]
  end

  def show
    render json: @business,
           methods: :active_promotions,
           include: [
             {
               address: {
                 only: :street,
                 include: [
                   suburb: {
                     only: :name
                   },
                   postcode: {
                     only: :code
                   },
                   state: {
                     only: :name
                   }
                 ]
               },
               category: {
                 only: :name
               },
               reviews: {},
               checkins: {
                 include: [
                   user: {
                     only: %i[id username profile_img_src]
                   },
                   business: {
                     only: %i[name id listing_img_src]
                   },
                   review: {
                     only: %i[rating content]
                   }
                 ]
               }
             }
           ]
  end

  def create
    # Create a Busines with the business_params function as attributes.
    business = Business.new(**business_params, address: Address.create(
      street: address_params[:street],
      suburb: Suburb.find_or_create_by(name: address_params[:suburb]),
      postcode: Postcode.find_or_create_by(code: address_params[:postcode]),
      state: State.find_or_create_by(name: address_params[:state])
    ))

    # If the business was created successfully, return the business, otherwise a 422 unprocessable entity.
    if business.save
      render json: business, include: [:address], status: :created
    else
      render json: { errors: business.errors }, status: :unprocessable_entity
    end
  end

  def update
    return unless authorize(@business.user)

    if @business.update(business_params)
      render json: @business
    else
      render json: { errors: @business.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    return unless authorize(@business.user)

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
    params
      .require(:business)
      .permit(
        :category_id,
        :user_id,
        :name,
        :description,
        :listing_img_src
      )
  end

  def address_params
    params.require(:business).require(:address).permit(:street, :suburb, :postcode, :state)
  end

  def search_params
    params.permit(:search, :filter, :limit)
  end
end
