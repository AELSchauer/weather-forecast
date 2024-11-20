class ForecastsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @greeting = "Hello, World!"
  end

  def create
    current = Api::OpenWeatherService.weather(lat: params[:location][:lat], lon: params[:location][:lon])
    forecasts = Api::OpenWeatherService.daily(lat: params[:location][:lat], lon: params[:location][:lon])

    render json: { current:, forecasts: }.to_json
  rescue => err
    render json: { error: err }, status: 400
  end
end
