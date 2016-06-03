require './raw_forecast'
require 'pry'

class DummyPrecise

  def get_forecast
    dummy = RawForecast.new date_of_event: (Time.now.tv_sec.to_s), location_zip: "27701"
    dummy.ctemp_event_hour = rand(12..40).to_s
    dummy.ftemp_event_hour = rand(50..90).to_s
    dummy.rain_chance = rand(1..100).to_s
    dummy.forecast_filled_date = Time.now.tv_sec.to_s
    dummy
  end

end
