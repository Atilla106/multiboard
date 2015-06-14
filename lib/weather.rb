require 'json'
require 'net/http'
require 'time'

class Weather
  attr_reader :weather, :weather_icon, :temperature, :min_temperature, :max_temperature, :wind_speed, :sunrise, :sunset, :morning_forecast, :afternoon_forecast

  def initialize
    owp_current
    owp_forecast
  end

  def to_s
    "#{@weather} #{weather_icon} #{@temperature} #{@wind_speed} #{@sunrise} #{@sunset} #{@min_temperature} #{@max_temperature}"
  end

  private
  def owp_current
    data = query("weather", q: "Cergy")

    @weather = data["weather"][0]["main"]
    @temperature = (data["main"]["temp"] - 273.15).to_i
    @wind_speed = data["wind"]["speed"]
    @sunrise = Time.at(data["sys"]["sunrise"])
    @sunset = Time.at(data["sys"]["sunset"])

    @weather_icon = icon(data["weather"][0])
  end

  def owp_forecast
    data = query("forecast/daily", q: "Cergy", cnt: 4)

    @min_temperature = (data["list"][0]["temp"]["min"] - 273.15).to_i
    @max_temperature = (data["list"][0]["temp"]["max"] - 273.15).to_i

    @morning_forecast = []
    @afternoon_forecast = []

    data["list"][1..3].each do |day|
      @morning_forecast << (day["temp"]["min"] - 273.15).to_i
      @afternoon_forecast << (day["temp"]["max"] - 273.15).to_i
    end
  end

  def icon(weather)
    urls = {
      "Clear Sky" => "http://i.imgur.com/aj7jR1p.png",
      "Clouds" => "http://i.imgur.com/WJAoRDq.png",
      "Thunderstorm" => "http://i.imgur.com/AddOin5.png",
      "Drizzle" => "http://i.imgur.com/HygDF63.png",
      "Rain" => "http://i.imgur.com/sVlvqse.png",
      "Snow" => "http://i.imgur.com/mK6rhTg.png",
    }

    weather["main"] = "Clear Sky" if weather["id"] == 800

    urls[weather["main"]] || "http://i.imgur.com/P3ubIsf.png"
  end

  def query(url, options = {})
    options.merge!({ :mode => "json" })
    uri = URI("http://api.openweathermap.org/data/2.5/#{url}")
    uri.query = URI.encode_www_form(options)
    JSON.parse(Net::HTTP.get(uri)) rescue {}
  end
end
