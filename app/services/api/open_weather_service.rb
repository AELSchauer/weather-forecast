class Api::OpenWeatherService
  include HTTParty

  API_KEY = ENV["OPEN_WEATHER_API_KEY"]
  base_uri "https://api.openweathermap.org"

  class << self
    # This will make a GET request to the Open Weather API
    #   to recieve the 7 day forecast for a given location
    # The response will return in English and imperial units.
    # @param {lat} : location latitude
    # @param {lon} : location longitude
    def daily(lat:, lon:)
      get("/data/2.5/forecast", {
        query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: API_KEY
        }
      })
    end

    # This will make a GET request to the Open Weather API
    #   to recieve the current weather for a given location
    # The response will return in English and imperial units.
    # @param {lat} : location latitude
    # @param {long} : location longitude
    def weather(lat:, lon:)
      get("/data/2.5/weather", {
        query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: API_KEY
        }
      })
    end

    # This overrides the base HTTParty.get method to add error handling.
    # Rails can log an error or warning to an external error monitoring / logging application (e.g Sentry)
    # Errors will create an on-call alert
    # Warnings will create a business hours alert
    # Infos will create simple logs
    def get(*args)
      response = super(*args)

      case response["cod"].to_i
      when 200
        response
      when 400
        Rails.logger.warn "[#{self}][400] Bad Request. endpoint: #{args[0]}; lat: #{args[1][:query][:lat]}; lon: #{args[1][:query][:lon]}"
        raise "API arguments invalid"
      when 401
        Rails.logger.error "[#{self}][401] API Token Invalid"
        raise "API token invalid"
      when 404
        Rails.logger.info "[#{self}][404] Data Missing"
        raise "API data missing"
      when 429
        Rails.logger.warn "[#{self}][424] Request Quote Exceeded"
        raise "API unavailable"
      else
        Rails.logger.error "[#{self}][#{response["cod"]}] Server Error. Contact OpenWeather support. query: #{args}; response: #{}"
        raise "API unavailable"
      end
    end
  end
end
