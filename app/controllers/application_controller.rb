class ApplicationController < ActionController::API
  def authenticate
    begin
      token = request.headers["Authorization"].split(" ")[1]
      # Get payload by decoding JWT. Args are token, key, "true" to validate (including ensuring not expired), and algorithm type.
      payload = JWT.decode(token, ENV["JWT_KEY"], true, { algorithm: "HS512" })[0]
      # Assign user email extracted from payload to an instance variable for use in controller actions
      @email = payload["email"]
    rescue
      # If token invalid or other error occurs during authentication, render error with 401 status
      render json: { error: "Invalid token" }, status: :unauthorized
    end

  end
end
