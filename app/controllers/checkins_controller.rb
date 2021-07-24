class CheckinsController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :set_checkin, only: [:show]
  before_action :authenticate, only: [:create]

  def index
    render status: :not_implemented
  end

  def show
    render json: @checkin,
           include: [
             { user: { only: :username } },
             { business: { only: :name } },
             { review: { only: [rating, :content] } },
           ]
  end

  def create
    @checkin = Checkin.new(checkin_params)

    if @checkin.save
      render json: @checkin
    else
      render json: { errors: @checkin.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_checkin
    @checkin = Checkin.find(params[:id])
  end

  def checkin_params
    params.permit(:user_id, :business_id)
  end
end
