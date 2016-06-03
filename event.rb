class Event

  attr_reader :title, :date, :zip_code

  def initialize title:, date:, zip_code:
    @title      = title
    @date       = date
    @zip_code   = zip_code
    # @forecast = RawForecast.new
  end

  def date_in_sec date
    Time.new( * (date.split("-")) ).tv_sec
  end

  def to_h
    {
      "title"   => @title,
      "date"    => @date
    }

    # hash = {}
    # self.instance_variables.each do |iv|
    #   hash[iv.to_s.delete("@")] =
    #     self.instance_variable_get(iv)
    # end
    # hash
  end

end
