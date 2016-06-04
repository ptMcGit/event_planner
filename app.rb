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
    raise e
    binding.pry
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
    if event_is_valid?
       DB[username].push create_new_event
       json(
         "status": "success",
         "message": "#{params[:title]} successfully added."
       )
    # else
    #   halt
    #   json(
    #     "status": "error",
    #     "message": "There was a problem with your event: #{params[:title]}."
    #   )
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

  def date
    Time.new( * (params["date"].split("-")) ).tv_sec
  end

  def event_is_valid?
    problems = []
    if event_is_duplicate?
      halt(
        json(
          "status": "error",
          "message": "#{params[:title]} has already been added."
        )
      )
    end

    params.keys.each do |field|
      case field
      when "date"
          problems.push date_is_valid?
      end
    end

    problems.flatten!

    unless problems.empty?
      halt(
        422,
        json("status": "error", "error": problems.flatten)
      )
    else
      return true
    end
  end

  def date_is_valid?
    problems = []
    begin
      Time.new(params["date"]).tv_sec
    rescue ArgumentError => e
      problems.push "The date you entered is invalid."
    end
    if date < Time.now.tv_sec
      problems.push "The date you have entered has already passed"
    end
    problems
  end

  def event_is_duplicate?
    x = DB[username].find do |o|
      o.date        == params["date"]
      o.title       == params["title"]
      o.zip_code    == params["zip_code"]
    end
    x
  end

  def create_new_event
    Event.new(
        title:         params[:title],
        date:          params[:date],
        zip_code:      params[:zip_code],
        duration_sec:  params[:duration_sec]
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
