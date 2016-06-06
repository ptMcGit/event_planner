class Event

  attr_reader :title, :date, :zip_code, :duration_sec

  def initialize title:, date:, zip_code:, duration_sec:
    @title          = title
    @date           = date
    @duration_sec   = duration_sec
    @zip_code       = zip_code
    @forecasts      = {}
  end

  def find_available_forecast forecast_date
    @forecasts.find { |h| h["date_of_event"] == forecast_date }
  end

  def is_stale? forecast
    staleness = Time.now.tv_sec - forecast["forecast_filled_date"]
    time_until_event = forecast["date_of_event"].to_i - Time.now.tv_sec

    one_hour = 3600
    one_day = 3600 * 24
    ten_days = 3600 * 24 * 10

    if time_until_event > ten_days
      return false
    elsif time_until_event > one_day
      return staleness > one_day
    elsif time_until_event < one_day
      return staleness > one_hour
    end
  end

  def populate_forecasts
    new_forecasts = []
    (0..@duration_sec.to_i).step(3600).to_a.each do |f|
      old_f = find_available_forecast((f + @date.to_i).to_s)
      if old_f.nil? || is_stale?(old_f)


        new_forecasts.push get_forecast((f + @date.to_i).to_s, @zip_code)
      else
        new_forecasts.push old_f
      end
    end
    @forecasts = new_forecasts
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
