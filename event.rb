class Event

  attr_reader :title, :date, :zip_code, :duration_sec

  def initialize title:, date:, zip_code:, duration_sec:
    @title          = title
    @date           = date
    @duration_sec   = duration_sec
    @zip_code       = zip_code
    # @forecast = RawForecast.new
  end

  def to_h
    {
      "title"           => @title,
      "date"            => @date,
      "zip_code"        => @zip_code,
      "duration_sec"    => @duration_sec
    }

    # hash = {}
    # self.instance_variables.each do |iv|
    #   hash[iv.to_s.delete("@")] =
    #     self.instance_variable_get(iv)
    # end
    # hash
  end

end
