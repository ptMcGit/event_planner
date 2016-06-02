require 'httparty'
require 'pry'
require 'json'
require './raw_forecast'

# example query for 10 day forecast in areacode 27701
# r = HTTParty.get "http://api.wunderground.com/api/#{ENV["WUNDERGROUND_KEY"]}/features/forecast10day/q/27701.json"
sent_raw_forecast = RawForecast.new date_in_s: "1341468000", location_zip: "27701"


def file_path file_name
  File.expand_path "../#{file_name}.json", __FILE__
end

r = JSON.parse(File.read file_path("example_weather_data"))

binding.pry
