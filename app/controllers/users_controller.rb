class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users, include: [:business], except: [:password_digest]
  end

  # GET /users/:id
  def show
    render json: @user, include: [:business], except: [:password_digest]
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
      render json: { token: @token }, status: :created
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
      render json: { token: @token }
    else
      # If login unsuccessful, render generic error message
      render json: "Incorrect username or password", status: :unauthorized
    end
  end

  # PATCH/PUT /users/:id
  def update
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
    params.permit(:email, :password, :username, :bio, :public)
  end

  def generate_token
    # JWT token payload contains user's email address and session expiry time (currently 1 hour)
    # Assumes @user variable has been set before this method is called
    payload = { email: @user.email, exp: Time.now.to_i + 3600 }
    # Create JWT token with payload, key and HS512 encryption
    # TODO: Replace "secretkey" with env variable
    @token = JWT.encode(payload, "secretkey", "HS512")
  end

end
