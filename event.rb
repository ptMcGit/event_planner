class Event

  attr_reader :title, :date, :zip_code, :duration_sec

  def initialize title:, date:, zip_code:, duration_sec:
    @title          = title
    @date           = date
    @duration_sec   = duration_sec
    @zip_code       = zip_code
    @forecasts      = []
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
        new_forecasts.push get_forecast( (f + @date.to_i).to_s )
      else
        new_forecasts.push old_f
      end
    end
    @forecasts = new_forecasts
  end

  def get_forecast forecast_date
    rf =  {
      "date_of_event"       => forecast_date,
      "location_zip"        => @zip_code,
      "rain_chance"         => nil,
      "ctemp_event_hour"    => nil,
      "ftemp_event_hour"    => nil,
      "ctemp_day_hilo"      => nil,
      "ftemp_day_hilo"      => nil,
      "forecast_filled_date"=> nil
    }
    w = (WeatherData.new(rf)).get_forecast
    binding.pry
  end

  def to_h
    {
      "title"           => @title,
      "date"            => @date,
      "zip_code"        => @zip_code,
      "duration_sec"    => @duration_sec,
      "forecasts"       => populate_forecasts
    }
  end

end
