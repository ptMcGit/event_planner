require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'json'
require './weather_data'

class Minitest::Test
  def file_path file_name
    File.expand_path "../weather_test_data/#{file_name}.json", __FILE__
  end
end

class ReadRequestTest < Minitest::Test

  def forecast_request
    {
                    "ctemp_day_hilo" => nil,
                    "ctemp_event_hour" => nil,
                    "date_of_event" => "1464984000",
                    "forecast_filled_date" => nil,
                    "ftemp_day_hilo" => nil,
                    "ftemp_event_hour" => nil,
                    "location_zip" => "27701",
                    "rain_chance" => nil
                  }
  end

  def test_have_date_of_events
    assert_equal "1464984000", forecast_request["date_of_event"]
  end

  def test_have_location_zip
    assert_equal "27701", forecast_request["location_zip"]
  end

end

class WeatherParserTest < Minitest::Test

  def test_can_parse_10day_daily
    daily_info = WeatherParser.new(JSON.parse(File.read(file_path("example_weather_data_by_day"))),(1341381600+345600).to_s)
    assert_equal nil, daily_info.ctemp_day_hilo
    assert_equal nil, daily_info.ftemp_day_hilo
    assert_equal nil, daily_info.rain_chance
    assert_equal nil, daily_info.ctemp_event_hour
    assert_equal nil, daily_info.ftemp_event_hour

    daily_info.parse!

    assert_equal ["23", "13"], daily_info.ctemp_day_hilo
    assert_equal ["73", "55"], daily_info.ftemp_day_hilo
    assert_equal "0", daily_info.rain_chance
    assert_equal nil, daily_info.ctemp_event_hour
    assert_equal nil, daily_info.ftemp_event_hour
  end

  def test_can_parse_10day_hourly
    hourly_info = WeatherParser.new(JSON.parse(File.read(file_path("example_weather_data_by_hour"))),(1464984000+25200).to_s)
    assert_equal nil, hourly_info.ctemp_day_hilo
    assert_equal nil, hourly_info.ftemp_day_hilo
    assert_equal nil, hourly_info.rain_chance
    assert_equal nil, hourly_info.ctemp_event_hour
    assert_equal nil, hourly_info.ftemp_event_hour

    hourly_info.parse!

    assert_equal nil, hourly_info.ctemp_day_hilo
    assert_equal nil, hourly_info.ftemp_day_hilo
    assert_equal "44", hourly_info.rain_chance
    assert_equal "24", hourly_info.ctemp_event_hour
    assert_equal "75", hourly_info.ftemp_event_hour
  end

end

class WeatherDataTestBasic < Minitest::Test

  attr_reader :processing

  def setup
    @processing = build_processing
  end

  def request!
    {
                    "ctemp_day_hilo" => nil,
                    "ctemp_event_hour" => nil,
                    "date_of_event" => "1464984000",
                    "forecast_filled_date" => nil,
                    "ftemp_day_hilo" => nil,
                    "ftemp_event_hour" => nil,
                    "location_zip" => "27701",
                    "rain_chance" => nil
                  }
  end

  def build_processing
    WeatherData.new request!
  end

  def parsed_info
    forecast_info = WeatherParser.new(JSON.parse(File.read(file_path("example_weather_data_by_hour"))),"1464984000")
    forecast_info.parse!
    forecast_info
  end

  def test_can_take_in_request_hash
    assert processing.request.is_a? Hash
  end

  def test_can_get_time_from_incoming_request
    assert_equal 1464984000, processing.time
  end

  def test_can_get_location_from_incoming_request
    assert_equal "27701", processing.location
  end

  def test_can_pass_weather_info_to_request_object_manually
    assert_equal nil, processing.request["rain_chance"]
    assert_equal nil, processing.request["ctemp_event_hour"]
    assert_equal nil, processing.request["ftemp_event_hour"]

    processing.request["rain_chance"] = parsed_info.rain_chance
    processing.request["ctemp_event_hour"] = parsed_info.ctemp_event_hour
    processing.request["ftemp_event_hour"] = parsed_info.ftemp_event_hour

    assert_equal "15", processing.request["rain_chance"]
    assert_equal "31", processing.request["ctemp_event_hour"]
    assert_equal "88", processing.request["ftemp_event_hour"]
  end

end

class WeatherDataTestAdv < Minitest::Test

  def request1
    {
                    "ctemp_day_hilo" => nil,
                    "ctemp_event_hour" => nil,
                    "date_of_event" => (Time.now.tv_sec + 86000).to_s,
                    "forecast_filled_date" => nil,
                    "ftemp_day_hilo" => nil,
                    "ftemp_event_hour" => nil,
                    "location_zip" => "27701",
                    "rain_chance" => nil
                  }
  end

  def request2
    {
                    "ctemp_day_hilo" => nil,
                    "ctemp_event_hour" => nil,
                    "date_of_event" => (Time.now.tv_sec + 432000).to_s,
                    "forecast_filled_date" => nil,
                    "ftemp_day_hilo" => nil,
                    "ftemp_event_hour" => nil,
                    "location_zip" => "27701",
                    "rain_chance" => nil
                  }
  end

  def request3
    {
                    "ctemp_day_hilo" => nil,
                    "ctemp_event_hour" => nil,
                    "date_of_event" => (Time.now.tv_sec + 1036800).to_s,
                    "forecast_filled_date" => nil,
                    "ftemp_day_hilo" => nil,
                    "ftemp_event_hour" => nil,
                    "location_zip" => "27701",
                    "rain_chance" => nil
                  }
  end

  def test_can_get_forecast_within_3days
    skip
    forecast = (WeatherData.new request1).get_forecast

    refute_equal nil, forecast["rain_chance"]
    refute_equal nil, forecast["ctemp_event_hour"]
    refute_equal nil, forecast["ftemp_event_hour"]

    assert_equal nil, forecast["ctemp_day_hilo"]
    assert_equal nil, forecast["ftemp_day_hilo"]
  end

  def test_can_get_forecast_between_3days_and_10days
    skip
    forecast = (WeatherData.new request2).get_forecast

    refute_equal nil, forecast["rain_chance"]
    refute_equal nil, forecast["ctemp_day_hilo"]
    refute_equal nil, forecast["ftemp_day_hilo"]

    assert_equal nil, forecast["ctemp_event_hour"]
    assert_equal nil, forecast["ftemp_event_hour"]
  end

  def test_cannot_get_forecast_beyond_10days
    skip
    forecast = (WeatherData.new request3).get_forecast

    assert_equal nil, forecast["rain_chance"]
    assert_equal nil, forecast["ctemp_event_hour"]
    assert_equal nil, forecast["ftemp_event_hour"]
    assert_equal nil, forecast["ctemp_day_hilo"]
    assert_equal nil, forecast["ftemp_day_hilo"]
  end

end


# -------example query for 10 day forecast in areacode 27701---------
# r = HTTParty.get "http://api.wunderground.com/api/#{ENV["WUNDERGROUND_KEY"]}/features/hourly10day/q/27701.json"

#-------- test info for hourly -----------
# sent_raw_forecast = RawForecast.new date_of_event: "1464984000", location_zip: "27701", born_on_date: "1464984000"

#-------- test info for daily -----------
#sent_raw_forecast = RawForecast.new date_of_event: "1341381600", location_zip: "27701", born_on_date: "1464984000"

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
