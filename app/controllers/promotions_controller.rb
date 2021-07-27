class PromotionsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  # User must be logged in to create a new promotion
  before_action :authenticate, except: %i[index]

  # Will trigger if the given business_id is not valid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def index
    # Order promotions with most recently-created first
    promotions = Promotion.active.order(created_at: :desc)
    # If a limit is given, limit to that number of results
    promotions.limit!(search_params[:limit]) if search_params[:limit]
    # Render promotions in the format and with the associations required by the React application
    render json: promotions, include: [
      business: {
        include: {
          reviews: {},
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
          }
        }
      }
    ]
  end

  def create
    # Find the business for which a promotion is being created
    @business = Business.find(params[:promotion][:business_id])
    # Only the owner of that business may create a promotion for it
    return unless authorize(@business.user)

    # Create a promotion with given attributes
    promotion = Promotion.new(promotion_params)

    # If the promotion was created successfully, return the promotion, otherwise a 422 unprocessable entity.
    if promotion.save
      render json: promotion, status: :created
    else
      render json: { errors: promotion.errors }, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.permit(:limit)
  end

  def promotion_params
    params.require(:promotion).permit(:business_id, :description, :end_date)
  end
end
