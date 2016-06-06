require 'pry'

def ctemp
  rand(12..40).to_s
end

def ftemp
  rand(50..90).to_s
end

def ctemp_day_hilo
  [ctemp, ctemp].sort
end

def ftemp_day_hilo
  [ftemp, ftemp].sort
end

def rain_chance
  rand(1..100).to_s
end

def get_dummy_forecast(forecast_date, zip_code, forecast_filled_date=Time.now.tv_sec, forecast_type="updated forecast")
  case forecast_type
  when "infinite forecast"
    return {
      "ctemp_day_hilo"        => [],
      "ftemp_day_hilo"        => [],
      "rain_chance"           => nil,
      "date_of_event"         => forecast_date,
      "forecast_filled_date"  => forecast_filled_date,
      "location_zip"          => zip_code,
      "ctemp_event_hour"      => nil,
      "ftemp_event_hour"      => nil
    }
  when "ten forecast"
    return {
      "ctemp_day_hilo"        => ctemp_day_hilo,
      "ftemp_day_hilo"        => ftemp_day_hilo,
      "rain_chance"           => rain_chance,
      "date_of_event"         => forecast_date,
      "forecast_filled_date"  => forecast_filled_date,
      "location_zip"          => zip_code,
      "ctemp_event_hour"      => nil,
      "ftemp_event_hour"      => nil
    }
  when "three forecast"
    return {
      "ctemp_day_hilo"        => ctemp_day_hilo,
      "ftemp_day_hilo"        => ftemp_day_hilo,
      "rain_chance"           => rain_chance,
      "date_of_event"         => forecast_date,
      "forecast_filled_date"  => forecast_filled_date,
      "location_zip"          => zip_code,
      "ctemp_event_hour"      => ctemp,
      "ftemp_event_hour"      => ftemp
    }
  when "updated forecast"
    return {
      "ctemp_day_hilo"        => ["Updated values"],
      "ftemp_day_hilo"        => ["Updated values"],
      "rain_chance"           => "Updated value",
      "date_of_event"         => forecast_date,
      "forecast_filled_date"  => forecast_filled_date,
      "location_zip"          => zip_code,
      "ctemp_event_hour"      => "Updated value",
      "ftemp_event_hour"      => "Updated value"
    }
  end
end




# class DummyForecast

#   attr_reader :ctemp_day_hilo,
#   :ftemp_day_hilo,
#   :rain_chance,
#   :date_of_event,
#   :forecast_filled_date,
#   :location_zip,
#   :ctemp_event_hour,
#   :ftemp_event_hour

#   def initialize date:, forecast_type:, forecast_filled_date:, location_zip:
#     binding.pry
#     @ctemp_day_hilo        = forecast_type["ctemp_day_hilo"]
#     @ftemp_day_hilo        = forecast_type["ftemp_day_hilo"]
#     @rain_chance           = forecast_type["rain_chance"]
#     @date_of_event         = date
#     @forecast_filled_date  = forecast_filled_date
#     @location_zip          = location_zip #forecast_type["location_zip"]
#     @ctemp_event_hour      = forecast_type["ctemp_event_hour"]
#     @ftemp_event_hour      = forecast_type["ftemp_event_hour"]
#   end

  # def to_h
  #   {
  #   "ctemp_day_hilo"        => @ctemp_day_hilo,
  #   "ftemp_day_hilo"        => @ftemp_day_hilo,
  #   "rain_chance"           => @rain_chance,
  #   "date_of_event"         => @date_of_event,
  #   "forecast_filled_date"  => @forecast_filled_date,
  #   "location_zip"          => @location_zip,
  #   "ctemp_event_hour"      => @ctemp_event_hour,
  #   "ftemp_event_hour"      => @ftemp_event_hour
  #   }
  # end
