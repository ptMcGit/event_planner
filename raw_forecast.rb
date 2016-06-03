class RawForecast

  attr_reader :date_in_sec, :location_zip, :ctemp_day_hilo, :ftemp_day_hilo, :rain_chance,
              :ctemp_event_hour, :ftemp_event_hour

  def initialize date_in_sec:, location_zip:
    @ctemp_day_hilo   = nil
    @ftemp_day_hilo   = nil
    @rain_chance      = nil
    @date_in_sec      = date_in_sec
    @location_zip     = location_zip
    @ctemp_event_hour = nil
    @ftemp_event_hour = nil
  end
end
