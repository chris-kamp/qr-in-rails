require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get: "/api/v1/users/1").to route_to("users#show", id: "1")
    end

    it "routes to #register" do
      expect(post: "/api/v1/users/register").to route_to("users#register")
    end

    it "routes to #login" do
      expect(post: "/api/v1/users/login").to route_to("users#login")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/users/1").to route_to("users#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/users/1").to route_to("users#update", id: "1")
    end

  end
end
