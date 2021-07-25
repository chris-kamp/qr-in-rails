class UsersController < ApplicationController
  # Do not wrap params received from post in an additional named hash
  wrap_parameters false
  before_action :set_user, only: %i[show show_public update destroy]

  # Require authentication to edit a user or retrieve a user's details
  before_action :authenticate, only: %i[show update]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: e }, status: :not_found
  end

  # GET /users/:id
  def show
    return unless authorize(@user)
    render json: @user, include: { business: { only: :id } }, except: [:password_digest]
  end

  # GET /users/:id/public
  # Retrieve only publically available information about a user, without requiring authentication
  def show_public
    render json: @user,
           only: %i[username profile_img_src bio],
           include: {
             checkins: {
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
               ],
             },
           }
  end

  # POST /users/register
  def register
    # Create new user from params
    @user = User.new(user_params)

    # Render user object as JSON
    if @user.save
      # Generate a session token
      generate_token

      # Render a JSON object containing the encoded token
      render json: {
               token: @token,
               user: {
                 username: @user.username,
                 email: @user.email,
                 id: @user.id,
               },
             },
             status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # # POST /users/login
  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      # Generate a JWT
      generate_token

      # Render a JSON object containing the encoded token
      render json: {
               token: @token,
               user: {
                 username: @user.username,
                 email: @user.email,
                 id: @user.id,
               },
             }
    else
      # If login unsuccessful, render generic error message
      render json: 'Incorrect username or password', status: :unauthorized
    end
  end

  # PATCH/PUT /users/:id
  def update
    return unless authorize(@user)
    if @user.update(user_params)
      render json: @user, except: [:password_digest]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:email, :password, :username, :bio, :public, :profile_img_src)
  end

  def generate_token
    # JWT token payload contains user's email address and session expiry time (currently 1 hour)
    # Assumes @user variable has been set before this method is called
    payload = { email: @user.email, exp: Time.now.to_i + (3600 * 24) }

    # Create JWT token with payload, key and HS512 encryption
    @token = JWT.encode(payload, ENV['JWT_KEY'], 'HS512')
  end
end
