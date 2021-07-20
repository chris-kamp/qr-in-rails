Rails.application.routes.draw do
  scope "/api/v1" do
    # Generate standard user routes except create and destroy
    resources :users, except: [:create, :destroy]

    # Create custom user routes for login and registration
    scope "/users" do
      post "/login", to: "users#login", as: "login_user"
      post "/register", to: "users#register", as: "register_user"
    end

    # Create standard routes for other resources
    resources :checkins
    resources :reviews
    resources :addresses
    resources :businesses do
      get :search, on: :collection
    end
    resources :categories
  end
end
