require "json"
require 'pry'
require './raw_forecast'

class WeatherDayParser

  attr_reader :path, :date_in_s, :celsius_temp, :fahrenheit_temp, :rain_chance

  def initialize path, date_in_s
    @path = path
    @date_in_s       = date_in_s
    @celsius_temp    = []
    @fahrenheit_temp = []
    @rain_chance     = nil
  end

  def parse!
    JSON.parse(File.read path)["forecast"]["simpleforecast"]["forecastday"].each do |day|
      if day["date"]["epoch"] == date_in_s
        @fahrenheit_temp.push(day["high"]["fahrenheit"])
        @fahrenheit_temp.push(day["low"]["fahrenheit"])
        @celsius_temp.push(day["high"]["celsius"])
        @celsius_temp.push(day["low"]["celsius"])
        @rain_chance = day["pop"]
      end
    end
  end
end
