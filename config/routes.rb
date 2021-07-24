Rails.application.routes.draw do
  resources :promotions
  scope '/api/v1' do
    # Generate standard user routes except create and destroy
    resources :users, except: %i[create destroy]

    # Create custom user routes
    scope '/users' do
      post '/login', to: 'users#login', as: 'login_user'
      post '/register', to: 'users#register', as: 'register_user'
      get '/:id/public', to: 'users#show_public', as: 'user_public'
    end

    # Create standard routes for other resources
    resources :checkins
    resources :reviews
    resources :addresses
    resources :businesses do
      get :search, on: :collection
    end
    resources :promotions
    resources :categories
  end
end
