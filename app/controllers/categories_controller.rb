class CategoriesController < ApplicationController
  def index
    render json: Category.order(created_at: :desc)
  end
end
