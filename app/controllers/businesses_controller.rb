class BusinessesController < ApplicationController
  before_action :set_business, except: [:index, :create]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  def index
    render json: Business.order(created_at: :desc)
  end

  def show
    render json: @business, include: [:address]
  end

  def create
    # Create a Busines with the business_params function as attributes.
    business = Business.new(business_params)

    # If the business was created successfully, return the business, otherwise a 422 unprocessable entity.
    if business.save
      render json: business, include: [:address], status: :created
    else
      render json: { errors: business.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @business.update(business_params)
      render json: @business
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @business.destroy
      render status: :no_content
    else
      render json: { errors: @business.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    # Permit only the attributes expected for Business.
    # business = params.require(:business).permit()
    business = params.permit(:category_id, :user_id, :name, :description, address: [:street, :suburb, :postcode, :state])

    # Change the [:address] object into the Address model, with Suburb, Postcode, State associations
    # using find_or_create_by to limit duplicate data.
    business[:address] = Address.new(
      street: params[:address][:street],
      suburb: Suburb.find_or_create_by(name: params[:address][:suburb]),
      postcode: Postcode.find_or_create_by(code: params[:address][:postcode]),
      state: State.find_or_create_by(name: params[:address][:state])
    )

    return business
  end
end
