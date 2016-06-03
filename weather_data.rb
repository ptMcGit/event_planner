require 'pry'
require 'json'
require './weather_parser'
require './raw_forecast'


class WeatherData
  attr_accessor :request
  attr_reader :request, :time, :location

  def initialize request
    @request  = request
    @time     = request.date_of_event
    @location = request.location_zip
  end



end
