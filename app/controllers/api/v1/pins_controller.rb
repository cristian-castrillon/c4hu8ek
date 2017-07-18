class Api::V1::PinsController < ApplicationController
  # User.find_by(email: request.headers['X-User-Email'], api_token: request.headers['X-Api-Token'] )
  before_action :authenticate

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def authenticate
      email = request.headers['X-User-Email']
      api_token = request.headers['X-Api-Token']
      @user = User.find_by(email: email, api_token: api_token)

      unless @user
        head status: :unauthorized
        return false
      end
    end
end
