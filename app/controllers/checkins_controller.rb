class CheckinsController < ApplicationController
    before_action :set_checkin, except: [:index, :create]
    before_action :authenticate, only: [:create]

    def index
        render json: @checkins, include: [:user, :business]
    end

    def show
        render json: @checkins
    end

    def create
        @checkin = Checkin.new(checkin_params)

        if @checkin.save
            render json: @checkin
        else
            render json: { errors: @checkin.errors }, status: :unprocessable_entity
        end
    end

    private

        def set_checkin
            @checkin = Checkin.find(params[:id])
        end

        def checkin_params
            params.permit(:user_id, :business_id, :content)
        end

end
