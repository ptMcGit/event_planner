require './raw_forecast'
require 'pry'

class DummyGeneral

  def get_forecast
    dummy = RawForecast.new date_of_event: (Time.now.tv_sec.to_s), location_zip: "27701"
    dummy.ctemp_day_hilo.push(rand(21..40).to_s).push(rand(12..20).to_s)
    dummy.ftemp_day_hilo.push(rand(71..90).to_s).push(rand(50..70).to_s)
    dummy.rain_chance = rand(1..100).to_s
    dummy.forecast_filled_date = Time.now.tv_sec.to_s
    dummy
  end

end

a = DummyGeneral.new
a = a.get_forecast
binding.pry
