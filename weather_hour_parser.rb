require "json"
require 'pry'
require './raw_forecast'

class WeatherHourParser

  attr_reader :input, :date_in_s, :celsius_temp, :fahrenheit_temp, :rain_chance

  def initialize input, date_in_s
    @input = input
    @date_in_s       = date_in_s
    @celsius_temp    = nil
    @fahrenheit_temp = nil
    @rain_chance     = nil
  end

  def parse!
    JSON.parse(input)["hourly_forecast"].each do |hour|
      if hour["FCTTIME"]["epoch"] == date_in_s
        @fahrenheit_temp = hour["temp"]["english"]
        @celsius_temp = hour["temp"]["metric"]
        @rain_chance = hour["pop"]
      end
    end
  end
end
