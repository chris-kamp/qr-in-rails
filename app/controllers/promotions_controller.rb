class PromotionsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  def create
    # Create a Pusines with the promotion_params function as attributes.
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
