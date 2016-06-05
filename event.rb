class Event

  attr_reader :title, :date, :zip_code, :duration_sec

  def initialize title:, date:, zip_code:, duration_sec:
    @title          = title
    @date           = date
    @duration_sec   = duration_sec
    @zip_code       = zip_code
    @forecasts      = {}
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

  def find_available_forecast forecast_date
    @forecasts.find { |h| h.date_of_event == forecast_date }
  end

  def is_stale? forecast
    forecast.forecast_filled_date + 3600 < Time.now.tv_sec
  end

  def get_forecast forecast_date
    rf =  RawForecast.new(
      date_of_event:    forecast_date,
      location_zip:     @zip_code
    )
    w = WeatherData.new(rf)
    w.get_forecast
  end

  def to_h
    {
      "title"           => @title,
      "date"            => @date,
      "zip_code"        => @zip_code,
      "duration_sec"    => @duration_sec,
      "forecasts"       => @forecasts
    }
  end

end
