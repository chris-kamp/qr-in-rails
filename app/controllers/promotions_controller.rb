class PromotionsController < ApplicationController
  before_action :authenticate, except: %i[index]

  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :authenticate

  # Will trigger if the given business_id is not valid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def index
    render json: Promotion.active.order(created_at: :desc), include: [
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

  def create
    @business = Business.find(params[:promotion][:business_id])
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

  def promotion_params
    params.require(:promotion).permit(:business_id, :description, :end_date)
  end
end
