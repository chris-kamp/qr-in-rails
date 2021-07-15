class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show update destroy]
  before_action :authenticate, only: %i[create update destroy]

  def index
    render status: :not_implemented
  end

  def show
    render json: @review,
           include: [{ user: { only: :username } }, business: { only: :name }]
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      render json: @review, status: :created
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.destroy
      render status: :no_content
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.permit(:user_id, :business_id, :content, :rating)
  end
end
