require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'pry'

require './event'
AdminUsername = ENV["ADMIN_USERNAME"] || File.read("./secret.txt").chomp

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

  get "/db" do
    if admin?
      json DB
    else
      status 403
      json []
    end
  end

  get "/events" do
    DB[username] ||= []
    show_events
  end

  post "/events" do
    DB[username] ||= []
    if event_is_valid? params
      DB[username].push create_new_event
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
    DB[username].delete_if { |e| e.title  == params["title"]}
    json "'#{params["title"]}' has been removed."
  end

  def require_authorization!
    unless username
      halt(
        401,
        json("status": "error", "error": "You must log in.")
      )
    end
  end

  def username
    request.env["HTTP_AUTHORIZATION"]
  end

  def admin?
    username == AdminUsername
  end

  def event_is_valid? event
    true
  end

  def create_new_event
    Event.new(
        title:        params[:title],
        date:         params[:date],
        zip_code:     params[:zip_code]
    )
  end

  def show_events
    events = []

    DB[username].each do |event|
     events.push event.to_h
    end

    json events
  end
end

EventPlanner.run! if $PROGRAM_NAME == __FILE__
