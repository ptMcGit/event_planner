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

  def event_is_valid? event
    true
  end


  post "/events" do
    DB[username] ||= []
    if event_is_valid? params
      DB[username].push params
      json(
        "status": "success",
        "message": "#{params[:title]} successfully added."
      )
    else
      json(
        "status": "error",
        "message": "There was a problem with your event: #{params[:title]}."
      )
    end

  end

  delete "/events" do
    DB[username].delete_if { |k,v| k["title"] == params["title"]}
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
