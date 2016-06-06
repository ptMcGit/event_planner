require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'

require "./event"
require "./dummy_forecasts"
require "./dummy_events"

class EventTestCase < Event

  attr_reader   :forecasts, :forecast_filled_date, :forecast_type

  def initialize title:, date:, zip_code:, duration_sec:, forecast_type:, forecast_filled_date:
    super(title: title, date: date, zip_code: zip_code, duration_sec: duration_sec)

    @forecast_type = forecast_type
    @forecast_filled_date = forecast_filled_date
    @forecasts = populate_dummy_forecasts
  end

  def populate_dummy_forecasts
    dummy_forecasts = []
    (0..@duration_sec.to_i).step(3600).to_a.each do |f|
      dummy_forecasts.push(get_dummy_forecast((f + @date.to_i).to_s, @zip_code, @forecast_filled_date, @forecast_type))
    end
    @forecasts = dummy_forecasts
  end

  def get_forecast forecast_date
    get_dummy_forecast forecast_date.to_s, @zip_code
  end


end

class EventTestCaseTests < Minitest::Test
   include Rack::Test::Methods
   require './dummy_events'

   def stale_by_days days=rand(50)
     Time.now.tv_sec - days * 24 * 3600
   end

   def stale_by_hours hours=1
     Time.now.tv_sec - hours * 3600
   end

   def current_date
     Time.now.tv_sec
   end

   def infinite_date
     x = Time.now.tv_sec + 1 + (3600 * 24 * (rand(10..50)))
     x - (x % 3600)
   end

   def ten_date
     x = Time.now.tv_sec + (3600 * 24 * (rand(3..10)))
     x - (x % 3600)
   end

   def three_date
     x = Time.now.tv_sec - 1 + (rand(0..(3600 * 24 * 3)))
     x - (x % 3600)
   end

   def current_date
     Time.now.tv_sec
   end

   def location_zip
     "90807"
   end

   def test_can_get_dummy_forecast
     x = get_dummy_forecast(
       current_date,
       location_zip,
       current_date,
       "infinite forecast"
     )
   end

   def test_can_create_event_test_case
     d = current_date
     x = EventTestCase.new **(Rainy_birthday), forecast_type: "infinite forecast", forecast_filled_date: d
     assert_equal 1, x.forecasts.length
     assert_equal [], x.forecasts[0]["ctemp_day_hilo"]
     assert_equal [], x.forecasts[0]["ftemp_day_hilo"]
     assert_equal nil, x.forecasts[0]["rain_chance"]

     assert_equal Rainy_birthday[:date], x.forecasts[0]["date_of_event"]
     assert_equal Rainy_birthday[:zip_code], x.forecasts[0]["location_zip"]
     assert_equal nil, x.forecasts[0]["ctemp_event_hour"]
     assert_equal nil, x.forecasts[0]["ftemp_event_hour"]
   end

   def test_can_create_test_case_with_multiple_forecasts
     d = current_date
     Socal_reggae[:date] = valid_future_date 1
     x = EventTestCase.new **(Socal_reggae), forecast_type: "three forecast", forecast_filled_date: d
     assert_equal 2, x.forecasts.count
     refute_empty x.forecasts[0]
     refute_empty x.forecasts[1]
   end

   focus



   def test_stale_forecasts_updated
     d = stale_by_days 10
     x = EventTestCase.new **(In_one_day_event), forecast_type: "three forecast", forecast_filled_date: d

     x.populate_forecasts
     assert_equal ["Updated values"], x.forecasts[0]["ctemp_day_hilo"]
     assert_equal In_one_day_event[:date], x.forecasts[0]["date_of_event"]
     assert x.forecasts[0]["forecast_filled_date"] > d

   end
end
