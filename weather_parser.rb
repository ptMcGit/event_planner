require "json"
require 'pry'
require './raw_forecast'

class WeatherParser

  attr_reader :input, :date_of_event, :ctemp_day_hilo, :ftemp_day_hilo,
              :rain_chance, :ctemp_event_hour, :ftemp_event_hour

  def initialize input, date_of_event
    @input            = input
    @date_of_event    = date_of_event
    @ctemp_day_hilo   = nil
    @ftemp_day_hilo   = nil
    @rain_chance      = nil
    @ctemp_event_hour = nil
    @ftemp_event_hour = nil
  end

  # def parse!
  #   if input["forecast"]
  #     input["forecast"]["simpleforecast"]["forecastday"].each do |day|
  #       if (day["date"]["epoch"].to_i >= date_of_event.to_i - 43200) && (day["date"]["epoch"].to_i < date_of_event.to_i + 43200)
  #         @ftemp_day_hilo = [(day["high"]["fahrenheit"])]
  #         @ftemp_day_hilo.push(day["low"]["fahrenheit"])
  #         @ctemp_day_hilo = [(day["high"]["celsius"])]
  #         @ctemp_day_hilo.push(day["low"]["celsius"])
  #         @rain_chance = day["pop"].to_s
  #       end
  #     end
  #   elsif input["hourly_forecast"]
  #     input["hourly_forecast"].each do |hour|
  #       if (hour["FCTTIME"]["epoch"].to_i >= date_of_event.to_i - 1800) && (hour["FCTTIME"]["epoch"].to_i < date_of_event.to_i + 1800)
  #         @ftemp_event_hour = hour["temp"]["english"]
  #         @ctemp_event_hour = hour["temp"]["metric"]
  #         @rain_chance = hour["pop"].to_s
  #       end
  #     end
  #   else
  #     #do nothing
  #   end
  # end

  def parse!
    if input["forecast"]
      day = input["forecast"]["simpleforecast"]["forecastday"].select{ |day| (day["date"]["epoch"].to_i >= date_of_event.to_i - 43200) && (day["date"]["epoch"].to_i < date_of_event.to_i + 43200)}
        @ftemp_day_hilo = [(day.first["high"]["fahrenheit"])]
        @ftemp_day_hilo.push(day.first["low"]["fahrenheit"])
        @ctemp_day_hilo = [(day.first["high"]["celsius"])]
        @ctemp_day_hilo.push(day.first["low"]["celsius"])
        @rain_chance = day.first["pop"].to_s
    elsif input["hourly_forecast"]
      hour = input["hourly_forecast"].select{ |hour| (hour["FCTTIME"]["epoch"].to_i >= date_of_event.to_i - 1800) && (hour["FCTTIME"]["epoch"].to_i < date_of_event.to_i + 1800)}
        @ftemp_event_hour = hour.first["temp"]["english"]
        @ctemp_event_hour = hour.first["temp"]["metric"]
        @rain_chance = hour.first["pop"].to_s
    else
      #do nothing
    end
  end
end
