require "json"
require 'pry'
require './raw_forecast'

class WeatherDayParser

  attr_reader :input, :date_of_event, :ctemp_day_hilo, :ftemp_day_hilo,
              :rain_chance, :ctemp_event_hour, :ftemp_event_hour

  def initialize input, date_of_event
    @input            = input
    @date_of_event    = date_of_event
    @ctemp_day_hilo   = []
    @ftemp_day_hilo   = []
    @rain_chance      = nil
    @ctemp_event_hour = nil
    @ftemp_event_hour = nil
  end

  def parse!
    raw = JSON.parse(File.read input)
    if raw["forecast"]
      raw["forecast"]["simpleforecast"]["forecastday"].each do |day|
        if day["date"]["epoch"] == date_of_event
          @ftemp_day_hilo.push(day["high"]["fahrenheit"])
          @ftemp_day_hilo.push(day["low"]["fahrenheit"])
          @ctemp_day_hilo.push(day["high"]["celsius"])
          @ctemp_day_hilo.push(day["low"]["celsius"])
          @rain_chance = day["pop"]
        end
      end
    elsif raw["hourly_forecast"]
      raw["hourly_forecast"].each do |hour|
        if hour["FCTTIME"]["epoch"] == date_of_event
          @ftemp_event_hour = hour["temp"]["english"]
          @ctemp_event_hour = hour["temp"]["metric"]
          @rain_chance = hour["pop"]
        end
      end
    else
      raise "Not valid data format"
    end
  end
end
