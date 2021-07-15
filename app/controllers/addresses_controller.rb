class AddressesController < ApplicationController
  before_action :set_address, except: [:index, :create]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def index
    render status: :not_implemented
  end

  def show
    render json: @address, include: [:business]
  end

  def create
    render status: :not_implemented
  end

  def update
    render status: :not_implemented
  end

  def destroy
    render status: :not_implemented
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end
end
