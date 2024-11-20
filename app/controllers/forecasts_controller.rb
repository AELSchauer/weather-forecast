class ForecastsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @greeting = "Hello, World!"
  end

  def create
    weather_data = Api::OpenWeatherService.weather(lat: params[:location][:lat], lon: params[:location][:lon])

    render json: weather_data.to_json
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @user }
    # end
  end
end
