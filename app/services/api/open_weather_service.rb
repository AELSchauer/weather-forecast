class Api::OpenWeatherService
  include HTTParty

  API_KEY = ENV["OPEN_WEATHER_API_KEY"]
  base_uri "https://api.openweathermap.org"

  class << self
    # This will make a GET request to the Open Weather API
    #   to recieve the forecast for a given location
    # Format each weather data object in the list
    # The response will return in English and imperial units.
    # @param {lat} : location latitude
    # @param {lon} : location longitude
    # @param {ppostcode} : location postcode / zipcode
    def daily(lat:, lon:, postcode:)
      Rails.cache.fetch("#{postcode}_daily", expires_in: 30.minutes) do
        response = get("/data/2.5/forecast", {
          query: {
            lat:,
            lon:,
            lang: "en",
            units: "imperial",
            appid: API_KEY
          }
        })
        response["list"].map! do |data|
          format(data, response["city"]["timezone"])
        end
        response
      end
    end

    # This will make a GET request to the Open Weather API
    #   to recieve the current weather for a given location
    # Format the weather data object
    # The response will return in English and imperial units.
    # @param {lat} : location latitude
    # @param {lon} : location longitude
    # @param {ppostcode} : location postcode / zipcode
    def weather(lat:, lon:, postcode:)
      Rails.cache.fetch("#{postcode}_weather", expires_in: 30.minutes) do
        response = get("/data/2.5/weather", {
          query: {
            lat:,
            lon:,
            lang: "en",
            units: "imperial",
            appid: API_KEY
          }
        })
        format(response, response["timezone"])
      end
    end

    # Take the wind degree and return the closest cardinal direction
    # @param {deg} : 360 degree integer
    def direction(deg)
      directions = [
        [ "N", 0 ],
        [ "NE", 45 ],
        [ "E", 90 ],
        [ "SE", 135 ],
        [ "S", 180 ],
        [ "SW", 225 ],
        [ "W", 270 ],
        [ "NW", 315 ],
        [ "N", 360 ]
      ]

      direction = directions.find do |dir, degBot|
        (degBot - 22.5) <= deg && deg <= (degBot + 22.5)
      end

      direction[0]
    end

    # Format the data for easier display on the FE
    # Display the date and time in the location's timezone
    # Show the cardinal direction the wind is blowing
    # @param {data} : weather data object
    # @param {timezone_offset_in_sec} : timezone offset from utc in seconds
    def format(data, timezone_offset_in_sec)
      tz_offset = ActiveSupport::TimeZone[timezone_offset_in_sec].formatted_offset
      date_time = Time.at(data["dt"]).utc.to_datetime.new_offset(tz_offset)
      data["date"] = date_time.strftime("%A, %B %-d, %Y")
      data["time"] = date_time.strftime("%-l:%M %p")
      data["wind"]["direction"] = direction(data["wind"]["deg"])
      data
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
