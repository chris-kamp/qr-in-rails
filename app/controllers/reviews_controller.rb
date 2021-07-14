class ReviewsController < ApplicationController
    # before_action :authenticate_user!
    
    def index
        @reviews = Review.all
        render json: @reviews, include: [:user, :business]
    end

    def show
        render json: @reviews
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
            params.permit(:user_id, :business_id, :content)
        end 
end
