require 'pry'
require 'json'
require 'httparty'
require './weather_parser'
require './raw_forecast'


class WeatherData
  attr_accessor :request
  attr_reader :request, :time, :location, :parsed_info, :url, :token

  def initialize request
    @request  = request
    @time = request.date_of_event.to_i
    @location = request.location_zip
    @parsed_info = nil
    @token = token = ENV["WUNDERGROUND_KEY"] || File.read("./token.txt").chomp
    @url = "http://api.wunderground.com/api/#{token}/features"
  end

  def update
    request["rain_chance"] = parsed_info.rain_chance
    request["ctemp_event_hour"] = parsed_info.ctemp_event_hour
    request["ftemp_event_hour"] = parsed_info.ftemp_event_hour
    request["ctemp_day_hilo"] = parsed_info.ctemp_day_hilo
    request["ftemp_day_hilo"] = parsed_info.ftemp_day_hilo
    request["forecast_filled_date"] = Time.now.tv_sec.to_s
  end

  def get_forecast
    get_data_from_wunderground
    update
    return request
  end

  def get_data_from_wunderground
    if time - Time.now.tv_sec <= 259200
      data_query = HTTParty.get "#{url}/hourly10day/q/#{location.to_i}.json"
    elsif time - Time.now.tv_sec <= 864000
      data_query = HTTParty.get "#{url}/forecast10day/q/#{location.to_i}.json"
    else
      data_query = {}.to_json
    end
    @parsed_info = WeatherParser.new(data_query, time)
    @parsed_info.parse!
  end

end
