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
      #dummy_forecasts.push(get_dummy_forecast((@date.to_i + f).to_s, @forecast_type))
      dummy_forecasts.push(get_dummy_forecast((f + @date.to_i).to_s, @zip_code, @forecast_filled_date, @forecast_type))
    end
    @forecasts = dummy_forecasts
  end

  def get_forecast forecast_date, zip_code
    get_dummy_forecast(forecast_date.to_s, zip_code)
  end

  def populate_forecasts
    new_forecasts = {}
    (0..@duration_sec.to_i).step(3600).to_a.each do |f|
      old_f = find_available_forecast((f + @date.to_i).to_s)
      if is_stale?(old_f) || (not (old_f))
      forecasts.push get_forecast((f + @date.to_i).to_s)
      else
        new_forecasts.push old_f
      end
      @forecasts = new_forecasts
    end
  end

end

class EventTestCaseTests < Minitest::Test
   include Rack::Test::Methods
   require './dummy_events'

   def stale_date
     Time.now.tv_sec - (3600..(3600 * 24 * (rand(0..50))))
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

   focus

   def test_can_create_event_test_case
     d = current_date
     x = EventTestCase.new **(Rainy_birthday), forecast_type: "infinite forecast", forecast_filled_date: d
     assert_equal 1, x.forecasts.length
     assert_equal [], x.forecasts[0]["ctemp_day_hilo"]
     assert_equal [], x.forecasts[0]["ftemp_day_hilo"]
     assert_equal nil, x.forecasts[0]["rain_chance"]
     binding.pry
     assert_equal Rainy_birthday[:date], x.forecasts[0]["date_of_event"]
     assert_equal Rainy_birthday[:zip_code], x.forecasts[0]["location_zip"]
     assert_equal nil, x.forecasts[0]["ctemp_event_hour"]
     assert_equal nil, x.forecasts[0]["ftemp_event_hour"]
     binding.pry
   end

end
