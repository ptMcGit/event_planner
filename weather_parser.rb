require "json"
require 'pry'
require './raw_forecast'

class WeatherParser

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
    if input["forecast"]
      input["forecast"]["simpleforecast"]["forecastday"].each do |day|
        if (day["date"]["epoch"].to_i >= date_of_event.to_i - 43200) && (day["date"]["epoch"].to_i < date_of_event.to_i + 43200)
          @ftemp_day_hilo.push(day["high"]["fahrenheit"])
          @ftemp_day_hilo.push(day["low"]["fahrenheit"])
          @ctemp_day_hilo.push(day["high"]["celsius"])
          @ctemp_day_hilo.push(day["low"]["celsius"])
          @rain_chance = day["pop"].to_s
        end
      end
    elsif input["hourly_forecast"]
      input["hourly_forecast"].each do |hour|
        if (hour["FCTTIME"]["epoch"].to_i >= date_of_event.to_i - 1800) && (hour["FCTTIME"]["epoch"].to_i < date_of_event.to_i + 1800)
          @ftemp_event_hour = hour["temp"]["english"]
          @ctemp_event_hour = hour["temp"]["metric"]
          @rain_chance = hour["pop"].to_s
        end
      end
    else
      raise "Not valid data format"
    end
  end
end
