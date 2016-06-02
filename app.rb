require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'pry'

DB = {}

class EventPlanner < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  error do |e|
    binding.pry
    raise e
  end

  before do
    require_authorization!
  end

  get "/events" do
    DB[username] ||= []
    json DB[username]
  end

  post "/events" do
    DB[username] ||= []
    DB[username].push params
    binding.pry
  end

  def require_authorization!
    unless username
      status 401
      halt 401, json("status": "error", "error": "You must log in.")
    end
  end

  def username
    request.env["HTTP_AUTHORIZATION"]
  end
end

EventPlanner.run! if $PROGRAM_NAME == __FILE__
