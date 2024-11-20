require "rails_helper"

describe Api::OpenWeatherService do
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
