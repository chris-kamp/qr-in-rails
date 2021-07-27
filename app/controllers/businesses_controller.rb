class BusinessesController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :set_business, except: %i[index create search]
  # User must be logged in to perform these actions
  before_action :authenticate, except: %i[index search show]

  # Rescue and render status 404 when record requested does not exist.
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  # GET /businesses
  def index
    # Business records ordered by their popularity
    businesses = Business.all.sort_by(&:weekly_checkin_count).reverse
    # If a limit is given, limit to that number of results
    businesses.take(search_params[:limit].to_i) if search_params[:limit]
    # Render the business, including associations with details required to display the business on the front end.
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

  # Given search parameters (filter and search), render only the results matching those parameters
  def search
    # Get category IDs to filter by
    filters =
      JSON(search_params[:filter])
      # Select those keys (category IDs) set to true in search params
      .select { |_id, bool| bool }
      .keys
      # Front-end sends keys with a leading underscore - remove it
      .map { |id| id.to_s[(1..-1)].strip }
    # Perform case insensitive search across business names and descriptions
    results =
      Business.where(
        'name ILIKE :search OR description ILIKE :search',
        search: "%#{search_params[:search]}%"
      )
    # Filter search results to obtain those which match the filtered categories
    results = results.filter_by_category(filters) unless filters.empty?

    # Render results in the format and with the associations required by the React application
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
    # Render the business with the given ID in the format and with the associations required by the React application
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
    # Create a Busines with the params returned by business_params as attributes.
    business = Business.new(business_params)

    # If the business was created successfully, return the business, otherwise a 422 unprocessable entity.
    if business.save
      render json: business, include: [:address], status: :created
    else
      render json: { errors: business.errors }, status: :unprocessable_entity
    end
  end

  def update
    # User can only update their own business
    # authorize will fail and render forbidden status if logged in user does not match @business.user (ie. the business owner)
    return unless authorize(@business.user)

    if @business.update(business_params)
      render json: @business
    else
      render json: { errors: @business.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    # User can only destroy their own business
    # authorize will fail and render forbidden status if logged in user does not match @business.user (ie. the business owner)
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
    business =
      params
      .require(:business)
      .permit(
        :category_id,
        :user_id,
        :name,
        :description,
        :listing_img_src,
        address: %i[street suburb postcode state]
      )

    # Change the [:address] object into the Address model, with Suburb, Postcode, State associations
    # using find_or_create_by to limit duplicate data.
    unless business[:address].nil?
      business[:address] =
        Address.new(
          street: business[:address][:street],
          suburb: Suburb.find_or_create_by(name: business[:address][:suburb]),
          postcode:
            Postcode.find_or_create_by(code: business[:address][:postcode]),
          state: State.find_or_create_by(name: business[:address][:state])
        )
    end

    business
  end

  def search_params
    params.permit(:search, :filter, :limit)
  end
end
