require 'pry'
require 'json'
require './weather_parser'
require './raw_forecast'


class WeatherData

  attr_reader :request, :time

  def initialize request
    @request  = request
    @time     = request.date_of_event
  end

  # def get_time
  #   @time = request.date_of_event
  # end

end
