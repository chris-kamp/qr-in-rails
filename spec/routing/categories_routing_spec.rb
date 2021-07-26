require 'rails_helper'

RSpec.describe CategoriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/categories').to route_to('categories#index')
    end
  end
end
