require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'httparty'
require 'json'
require './weather_parser'
require './raw_forecast'
require './weather_data'

class Minitest::Test
  def file_path file_name
    File.expand_path "../weather_test_data/#{file_name}.json", __FILE__
  end
end

class RawForecastTest < Minitest::Test

  def forecast_request
    RawForecast.new date_of_event: "1464969600", location_zip: "27701", born_on_date: "1464969600"
  end

  def test_have_date_of_events
    assert_equal "1464969600", forecast_request.date_of_event
  end

  def test_have_location_zip
    assert_equal "27701", forecast_request.location_zip
  end

  def test_have_born_on_date
    assert_equal "1464969600", forecast_request.born_on_date
  end

end

class WeatherParserTest < Minitest::Test

  def test_can_parse_10day_daily
    forecast_info = WeatherParser.new(file_path("example_weather_data_by_day"),"1341381600")
    assert_equal [], forecast_info.ctemp_day_hilo
    assert_equal [], forecast_info.ftemp_day_hilo
    assert_equal nil, forecast_info.rain_chance
    assert_equal nil, forecast_info.ctemp_event_hour
    assert_equal nil, forecast_info.ftemp_event_hour

    forecast_info.parse!

    assert_equal ["24", "13"], forecast_info.ctemp_day_hilo
    assert_equal ["75", "55"], forecast_info.ftemp_day_hilo
    assert_equal "0", forecast_info.rain_chance
    assert_equal nil, forecast_info.ctemp_event_hour
    assert_equal nil, forecast_info.ftemp_event_hour
  end

  def test_can_parse_10day_hourly
    forecast_info = WeatherParser.new(file_path("example_weather_data_by_hour"),"1464969600")
    assert_equal [], forecast_info.ctemp_day_hilo
    assert_equal [], forecast_info.ftemp_day_hilo
    assert_equal nil, forecast_info.rain_chance
    assert_equal nil, forecast_info.ctemp_event_hour
    assert_equal nil, forecast_info.ftemp_event_hour

    forecast_info.parse!

    assert_equal [], forecast_info.ctemp_day_hilo
    assert_equal [], forecast_info.ftemp_day_hilo
    assert_equal "15", forecast_info.rain_chance
    assert_equal "30", forecast_info.ctemp_event_hour
    assert_equal "86", forecast_info.ftemp_event_hour
  end

  def test_can_raise_error_if_incorrect_format
    assert_raises "Not valid data format" do
      forecast_info = WeatherParser.new(file_path("example_data_conditions"),"1464969600")
      forecast_info.parse!
    end
  end
end

class WeatherDataTest < Minitest::Test

  def incoming
    RawForecast.new date_of_event: "1464969600", location_zip: "27701", born_on_date: "1464969600"
  end

  def forecast
    WeatherData.new incoming
  end

  def test_can_take_in_RawForecast_object
    assert forecast.request.is_a? RawForecast
  end

  def test_can_get_time_from_incoming_request
    assert_equal "1464969600", forecast.time
  end

end


# -------example query for 10 day forecast in areacode 27701---------
# r = HTTParty.get "http://api.wunderground.com/api/#{ENV["WUNDERGROUND_KEY"]}/features/hourly10day/q/27701.json"

#-------- test info for hourly -----------
# sent_raw_forecast = RawForecast.new date_of_event: "1464969600", location_zip: "27701", born_on_date: "1464969600"

#-------- test info for daily -----------
#sent_raw_forecast = RawForecast.new date_of_event: "1341381600", location_zip: "27701", born_on_date: "1464969600"

# -------------------helpful code blocks--------------------
# f = File.open "weather_test_data/example_weather_data_by_hour.json", "w"
#
# f.puts "#{r.to_json}"
#
# f.close
#
# r = r.to_json
# forecast_info = WeatherHourParser.new(r,"1464908400")
# forecast_info.parse!
#
