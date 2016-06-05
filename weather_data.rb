require 'pry'
require 'json'
require './weather_parser'
require './raw_forecast'


class WeatherData
  attr_accessor :request
  attr_reader :request, :time, :location, :parsed_info

  def initialize request
    @request  = request
    @time     = request["date_of_event"].to_i
    @location = request["location_zip"]
    @parsed_info = nil
  end

  def update
    #do the actual updating
    request["rain_chance"] = parsed_info.rain_chance
    request["ctemp_event_hour"] = parsed_info.ctemp_event_hour
    request["ftemp_event_hour"] = parsed_info.ftemp_event_hour
    request["ctemp_day_hilo"] = parsed_info.ctemp_day_hilo
    request["ftemp_day_hilo"] = parsed_info.ftemp_day_hilo
    request["forecast_filled_date"] = Time.now.to_s
  end

  def get_forecast
    #sends back the updated rawforecast object
    get_data_from_wunderground
    update
    return request
  end

  def get_data_from_wunderground
    #use the parser here
    if time - Time.now >= 259200
      data_query = HTTParty.get "http://api.wunderground.com/api/#{ENV["WUNDERGROUND_KEY"]}/features/hourly10day/q/#{location.to_i}.json"
    elsif time - Time.now >= 864000
      data_query = HTTParty.get "http://api.wunderground.com/api/#{ENV["WUNDERGROUND_KEY"]}/features/forecast10day/q/#{location.to_i}.json"
    else
      data_query = {}.to_json
    end

    @parsed_info = WeatherParser.new(data_query)

  end

end
