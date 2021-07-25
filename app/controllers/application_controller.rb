class ApplicationController < ActionController::API
  def authenticate
    begin
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

  def authorize(permitted_user)
    unless @current_user == permitted_user
      render status: :unauthorized
      return false
    end
    return true
  end
end
