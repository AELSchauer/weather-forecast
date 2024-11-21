require "rails_helper"

describe Api::OpenWeatherService do
  describe "API requests" do
    describe ".daily" do
      it "returns a successful request" do
        response_body = JSON.parse(File.read("./spec/fixtures/belgrade_daily.json"))
        lat = response_body["city"]["coord"]["lat"]
        lon = response_body["city"]["coord"]["lon"]

        stub_request(:get, described_class.base_uri + "/data/2.5/forecast")
          .with(query: {
            lat:,
            lon:,
            lang: "en",
            units: "imperial",
            appid: described_class::API_KEY
          })
          .to_return_json(body: response_body)

        expect { described_class.daily(lat:, lon:) }.not_to raise_error
        expect(described_class.daily(lat:, lon:)["cod"].to_i).to eq(200)
      end
    end

    describe ".weather" do
      it "returns a successful request" do
        response_body = JSON.parse(File.read("./spec/fixtures/belgrade_weather.json"))
        lat = response_body["coord"]["lat"]
        lon = response_body["coord"]["lon"]

        stub_request(:get, described_class.base_uri + "/data/2.5/weather")
          .with(query: {
            lat:,
            lon:,
            lang: "en",
            units: "imperial",
            appid: described_class::API_KEY
          })
          .to_return_json(body: response_body)

        expect { described_class.weather(lat:, lon:) }.not_to raise_error
        expect(described_class.weather(lat:, lon:)["cod"].to_i).to eq(200)
      end
    end

    it "raises an error if the lat or long is invalid" do
      lat = "bad"
      lon = "data"

      stub_request(:get, described_class.base_uri + "/data/2.5/forecast")
        .with(query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: described_class::API_KEY
        })
        .to_return_json(body: { "cod" => "400" }.to_json)

      expect { described_class.daily(lat:, lon:) }.to raise_error("API arguments invalid")
    end

    it "raises an error if the API key is invalid" do
      lat = 20
      lon = 20

      stub_const("Api::OpenWeatherService::API_KEY", "BAD_DATA")
      stub_request(:get, described_class.base_uri + "/data/2.5/forecast")
        .with(query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: "BAD_DATA"
        })
        .to_return_json(body: { "cod" => "401" }.to_json)

      expect { described_class.daily(lat:, lon:) }.to raise_error("API token invalid")
    end

    it "raises an error if API data is missing" do
      lat = 20
      lon = 20

      stub_request(:get, described_class.base_uri + "/data/2.5/forecast")
        .with(query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: described_class::API_KEY
        })
        .to_return_json(body: { "cod" => "404" }.to_json)

      expect { described_class.daily(lat:, lon:) }.to raise_error("API data missing")
    end

    it "raises an error if API data is missing" do
      lat = 20
      lon = 20

      stub_request(:get, described_class.base_uri + "/data/2.5/forecast")
        .with(query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: described_class::API_KEY
        })
        .to_return_json(body: { "cod" => "424" }.to_json)

      expect { described_class.daily(lat:, lon:) }.to raise_error("API unavailable")
    end

    it "raises an error if API data is missing" do
      lat = 20
      lon = 20

      stub_request(:get, described_class.base_uri + "/data/2.5/forecast")
        .with(query: {
          lat:,
          lon:,
          lang: "en",
          units: "imperial",
          appid: described_class::API_KEY
        })
        .to_return_json(body: { "cod" => "500" }.to_json)

      expect { described_class.daily(lat:, lon:) }.to raise_error("API unavailable")
    end
  end

  describe ".direction" do
    it 'returns N if degree is > 337.5° or <= 22.5°' do
      expect(described_class.direction(337.5)).to_not eq("N")
      expect(described_class.direction(337.6)).to eq("N")
      expect(described_class.direction(0)).to eq("N")
      expect(described_class.direction(22.5)).to eq("N")
      expect(described_class.direction(22.6)).to_not eq("N")
    end
    it 'returns NE if degree is > 22.5° or <= 67.5°' do
      expect(described_class.direction(22.5)).to_not eq("NE")
      expect(described_class.direction(22.6)).to eq("NE")
      expect(described_class.direction(45)).to eq("NE")
      expect(described_class.direction(67.5)).to eq("NE")
      expect(described_class.direction(67.6)).to_not eq("NE")
    end
    it 'returns E if degree is > 67.5° or <= 112.5°' do
      expect(described_class.direction(67.5)).to_not eq("E")
      expect(described_class.direction(67.6)).to eq("E")
      expect(described_class.direction(90)).to eq("E")
      expect(described_class.direction(112.5)).to eq("E")
      expect(described_class.direction(112.6)).to_not eq("E")
    end
    it 'returns SE if degree is > 112.5° or <= 157.5°' do
      expect(described_class.direction(112.5)).to_not eq("SE")
      expect(described_class.direction(112.6)).to eq("SE")
      expect(described_class.direction(135)).to eq("SE")
      expect(described_class.direction(157.5)).to eq("SE")
      expect(described_class.direction(157.6)).to_not eq("SE")
    end
    it 'returns S if degree is > 157.5° or <= 202.5°' do
      expect(described_class.direction(157.5)).to_not eq("S")
      expect(described_class.direction(157.6)).to eq("S")
      expect(described_class.direction(180)).to eq("S")
      expect(described_class.direction(202.5)).to eq("S")
      expect(described_class.direction(202.6)).to_not eq("S")
    end
    it 'returns SW if degree is > 202.5° or <= 247.5°' do
      expect(described_class.direction(202.5)).to_not eq("SW")
      expect(described_class.direction(202.6)).to eq("SW")
      expect(described_class.direction(225)).to eq("SW")
      expect(described_class.direction(247.5)).to eq("SW")
      expect(described_class.direction(247.6)).to_not eq("SW")
    end
    it 'returns W if degree is > 247.5° or <= 292.5°' do
      expect(described_class.direction(247.5)).to_not eq("W")
      expect(described_class.direction(247.6)).to eq("W")
      expect(described_class.direction(270)).to eq("W")
      expect(described_class.direction(292.5)).to eq("W")
      expect(described_class.direction(292.6)).to_not eq("W")
    end
    it 'returns NW if degree is > 292.5° or <= 337.5°' do
      expect(described_class.direction(292.5)).to_not eq("NW")
      expect(described_class.direction(292.6)).to eq("NW")
      expect(described_class.direction(315)).to eq("NW")
      expect(described_class.direction(337.5)).to eq("NW")
      expect(described_class.direction(337.6)).to_not eq("NW")
    end
  end

  describe ".format" do
    describe "when the timezone is a previous 'year'" do
      it "saves a human readable date and time to the object" do
        time_in_seconds = Time.new(2024, 1, 1, 0, 0, 0, "+00:00").to_i
        seconds_offset = -60 * 60 * 3

        response = described_class.format({ "dt" => time_in_seconds, "wind" => { "deg" => 0 } }, seconds_offset)
        expect(response["date"]).to eq("Sunday, December 31, 2023")
        expect(response["time"]).to eq("9:00 PM")
      end
    end

    describe "when the timezone is a next 'year'" do
      it "saves a human readable date and time to the object" do
        time_in_seconds = Time.new(2023, 12, 31, 21, 0, 0, "+00:00").to_i
        seconds_offset = 60 * 60 * 3

        response = described_class.format({ "dt" => time_in_seconds, "wind" => { "deg" => 0 } }, seconds_offset)
        expect(response["date"]).to eq("Monday, January 1, 2024")
        expect(response["time"]).to eq("12:00 AM")
      end
    end
  end
end
