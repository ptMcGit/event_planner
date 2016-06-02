require "json"
require 'pry'

class WeatherParser

  attr_reader :path, :users, :data, :items

  def initialize path
    @path = path
    @users = []
    @data = JSON.parse(File.read path)
    @items = []
  end

  def parse!
    data["users"].each do |user|
      @users.push(User.new user.values[0],
                           user.values[1],
                           user.values[2])
    end
    data["items"].each do |item|
      @items.push(Item.new item.values[0],
                           item.values[1],
                           item.values[2],
                           item.values[3])
    end
  end
end
