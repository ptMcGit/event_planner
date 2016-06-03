class RawForecast

  attr_reader :date_of_event, :location_zip, :ctemp_day_hilo, :ftemp_day_hilo, :rain_chance,
              :ctemp_event_hour, :ftemp_event_hour, :born_on_date

  def initialize date_of_event:, location_zip:, born_on_date:
    @ctemp_day_hilo   = nil
    @ftemp_day_hilo   = nil
    @rain_chance      = nil
    @date_of_event    = date_of_event
    @born_on_date     = born_on_date
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
