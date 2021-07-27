class ApplicationController < ActionController::API
  # Authenticate user by JWT token provided with request. If no token or invalid token, render unauthorised status.
  def authenticate
    begin
      # Extract token from request headers
      token = request.headers['Authorization'].split(' ')[1]

      # Get payload by decoding JWT. Args are token, key, "true" to validate (including ensuring not expired), and algorithm type.
      payload =
        JWT.decode(token, ENV['JWT_KEY'], true, { algorithm: 'HS512' })[0]

      # Assign user and email extracted from payload to an instance variable for use in controller actions
      @email = payload['email']
      @current_user = User.find_by_email!(payload['email'])
    rescue StandardError
      # If token invalid or other error occurs during authentication, render error with 401 status
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  # Given a permitted user, check that the current user (defined in #authenticate) is that user and return true if so. Otherwise, render forbidden status and return false.
  def authorize(permitted_user)
    unless @current_user == permitted_user
      render status: :forbidden
      return false
    end
    return true
  end

  # Given a prohibited user, check that the current user defined in #authenticate is NOT that user. If they are, return true and render forbidden status. Otherwise, return false.
  def exclude(prohibited_user)
    if @current_user == prohibited_user
      render status: :forbidden
      return true
    end
    return false
  end
end
