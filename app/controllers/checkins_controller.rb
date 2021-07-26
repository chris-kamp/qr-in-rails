class CheckinsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :authenticate

  # Will trigger if the given business_id or user_id is not valid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def create
    # Current user must match the given user_id, and must not be the owner of the business with the given business_id
    @user = User.find(params[:user_id])
    return unless authorize(@user)
    @business = Business.find(params[:business_id])
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
