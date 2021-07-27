class ReviewsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  # User must be logged in to create a review
  before_action :authenticate

  # Will trigger if the given checkin_id is not valid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def create
    # Find the checkin to which the review will belong
    @checkin = Checkin.find(params[:checkin_id])
    # Only the user associated with that checkin may create a review for it
    return unless authorize(@checkin.user)
    # The owner of a business cannot review that business
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
