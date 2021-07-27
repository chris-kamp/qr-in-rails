class CheckinsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  # User must be logged in to check in at a business
  before_action :authenticate, only: :create

  # Will trigger if the given business_id or user_id is not valid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def index
    @checkins = Checkin.order(created_at: :desc)
    @checkins.limit!(params[:limit]) if params[:limit]
    render json: @checkins,
           only: [:id, :created_at],
           include: [
             user: {
               only: %i[username id profile_img_src],
             },
             business: {
               only: %i[name id],
             },
             review: {
               only: %i[rating content],
             },
           ]
  end

  def create
    # Find the user with the id for which a checkin is to be created
    @user = User.find(params[:user_id])
    # A user may only "create" a checkin associated with their own user id
    return unless authorize(@user)
    # Find the business for which a checkin is to be created
    @business = Business.find(params[:business_id])
    # A user may not check in at a business of which they are the owner
    return if exclude(@business.user)

    @checkin = Checkin.new(checkin_params)

    if @checkin.save
      render json: @checkin
    else
      render json: { errors: @checkin.errors }, status: :unprocessable_entity
    end
  end

  private

  def checkin_params
    params.permit(:user_id, :business_id)
  end
end
