class RawForecast

  attr_reader :date_in_s, :location_zip, :celsius_temp, :fahrenheit_temp, :rain_chance

  def initialize date_in_s:, location_zip:, celsius_temp: nil, fahrenheit_temp: nil, rain_chance: nil
    @celsius_temp    = celsius_temp
    @fahrenheit_temp = fahrenheit_temp
    @rain_chance     = rain_chance
    @date_in_s       = date_in_s
    @location_zip    = location_zip
  end
end
