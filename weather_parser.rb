require "json"
require 'pry'
require './raw_forecast'

class WeatherParser

  attr_reader :path, :data, :celsius_temp, :fahrenheit_temp, :rain_chance

  def initialize path
    @path = path
    @celsius_temp    = []
    @fahrenheit_temp = []
    @rain_chance     = nil
    @data = JSON.parse(File.read path)
  end

  def parse!
    data["forecast"]["simpleforecast"]["forecastday"].each do |day|
      if day["date"]["epoch"] == "1341381600"
        @fahrenheit_temp.push(day["high"]["fahrenheit"])
        @fahrenheit_temp.push(day["low"]["fahrenheit"])
        @celsius_temp.push(day["high"]["celsius"])
        @celsius_temp.push(day["low"]["celsius"])
        @rain_chance = day["pop"]
      end
    end
  end
end
