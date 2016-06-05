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
  require "./dummy_events"
  attr_reader   :forecasts, :forecast_type
  def initialize title:, date:, zip_code:, duration_sec:, forecast_type:, forecast_filled_date:
    super(title: title, date: date, zip_code: zip_code, duration_sec: duration_sec)
    #@forecasts = get_phony_forecasts
    @forecast_type = forecast_type
    @forecast_filled_date = forecast_filled_date
    @forecasts = populate_dummy_forecasts
    binding.pry

  end

  def populate_dummy_forecasts
    dummy_forecasts = []

    (0..@duration_sec.to_i).step(3600).to_a.each do |f|
      #dummy_forecasts.push(get_dummy_forecast((@date.to_i + f).to_s, @forecast_type))
      binding.pry
      dummy_forecasts.push(get_forecast(f + @date.to_i))
    end
    @forecasts = dummy_forecasts
  end

  def get_forecast forecast_date
    get_dummy_forecast(forecast_date.to_s, @forecast_type)
  end

  def populate_forecasts
    new_forecasts = {}
    (0..@duration_sec.to_i).step(3600).to_a.each do |f|
      old_f = find_available_forecast(f + @date.to_i)
      if is_stale?(old_f) || (not (old_f))
      forecasts.push get_forecast(f + @date.to_i)
      else
        new_forecasts.push old_f
      end
      @forecasts = new_forecasts
    end
  end


  def get_dummy_forecast date, forecast_type
    binding.pry
    #return DummyForecast.new(infinite_forecast(date))
    return DummyForecast.new date: date, forecast_type: forecast_type, forecast_filled_date: @forecast_filled_date, location_zip: @location_zip
  end


   def infinite_date
     x = Time.now.tv_sec + 1 + (3600 * 24 * (rand(10..50)))
     x - (x % 3600)
   end

   def infinite_forecast filled_date
     {
       "ctemp_day_hilo"        => [],
       "ftemp_day_hilo"        => [],
       "rain_chance"           => nil,
       "date_of_event"         => infinite_date,
       "forecast_filled_date"  => filled_date,
       "location_zip"          => location_zip,
       "ctemp_event_hour"      => nil,
       "ftemp_event_hour"      => nil
     }
   end

   def location_zip
     "90807"
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

   def ten_date
     x = Time.now.tv_sec + (3600 * 24 * (rand(3..10)))
     x - (x % 3600)
   end

   def ten_forecast filled_date
     {
       "ctemp_day_hilo"        => ctemp_day_hilo,
       "ftemp_day_hilo"        => ftemp_day_hilo,
       "rain_chance"           => rain_chance,
       "date_of_event"         => ten_date,
       "forecast_filled_date"  => filled_date,
       "location_zip"          => location_zip,
       "ctemp_event_hour"      => [],
       "ftemp_event_hour"      => []
     }
   end

   def three_date
     x = Time.now.tv_sec - 1 + (rand(0..(3600 * 24 * 3)))
     x - (x % 3600)
   end

   def three_forecast filled_date
     {
       "ctemp_day_hilo"        => ctemp_day_hilo,
       "ftemp_day_hilo"        => ftemp_day_hilo,
       "rain_chance"           => rain_chance,
       "date_of_event"         => three_date,
       "forecast_filled_date"  => filled_date,
       "location_zip"          => location_zip,
       "ctemp_event_hour"      => [],
       "ftemp_event_hour"      => []
     }
   end

   def current_date
     Time.now.tv_sec
   end

   def test_can_get_dummy_forecast
     #     x = DummyForecast.new(infinite_forecast(current_date))

   end

   def test_can_create_event_test_case
     x = EventTestCase.new **(Rainy_birthday), forecast_type: "infinite_forecast", forecast_filled_date: current_date
binding.pry

   end

end
