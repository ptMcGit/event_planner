class RawForecast
  attr_accessor :ctemp_day_hilo, :ftemp_day_hilo, :rain_chance,
                :ctemp_event_hour, :ftemp_event_hour, :forecast_filled_date
  attr_reader :date_of_event, :location_zip, :ctemp_day_hilo, :ftemp_day_hilo, :rain_chance,
              :ctemp_event_hour, :ftemp_event_hour, :born_on_date,
              :forecast_filled_date

  def initialize date_of_event:, location_zip:
    @ctemp_day_hilo   = []
    @ftemp_day_hilo   = []
    @rain_chance      = nil
    @date_of_event    = date_of_event
    @forecast_filled_date     = nil
    @location_zip     = location_zip
    @ctemp_event_hour = nil
    @ftemp_event_hour = nil
  end

  def get_best_forecast

  end

  def forecast_beyond_10

  end

  def forecast_10_to_3

  end

  def forecast_under_3

  end

end
