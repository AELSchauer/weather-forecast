class ForecastsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @greeting = "Hello, World!"
  end

  def create
    current = Api::OpenWeatherService.weather(lat: location[:lat], lon: location[:lon], postcode: location[:postcode])
    forecasts = Api::OpenWeatherService.daily(lat: location[:lat], lon: location[:lon], postcode: location[:postcode])

    render json: { current:, forecasts: }.to_json
  rescue => err
    render json: { error: err }, status: 400
  end

  def location
    params.require(:location).permit(:lat, :lon, :postcode)
  end
end
