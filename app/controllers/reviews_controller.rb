class ReviewsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :authenticate

  # Will trigger if the given checkin_id is not valid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def create
    @checkin = Checkin.find(params[:checkin_id])
    return unless authorize(@checkin.user)
    return if exclude(@checkin.business.user)

    @review = Review.new(review_params)
    if @review.save
      render json: @review, status: :created
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.permit(:checkin_id, :content, :rating)
  end
end
