# Event planner user interface

require 'httparty'

require 'pry'

Url = "http://localhost:4567"
#Url = "http://tiy-jjzh-event-planner.herokuapp.com"

class MyApi
  attr_reader :headers, :url

  def initialize url
    @url = url
  end

  def login_as username, pass
    @headers = { "Authorization" => username + ":" + pass }
  end

  def view_events
    make_request :get, "/events"
  end

  def create_new_event title:, date:, zip_code:, duration_sec:
                            make_request :post, "/events",  query: {
                                           title: title,
                                           date: date,
                                           zip_code: zip_code,
                                           duration_sec: duration_sec
                                         }
  end

  def delete_event title:
                     make_request :delete, "/events", query: {
                                    title: title
                                  }
  end


  def make_request verb, endpoint, options={}
    options[:headers] = headers
    # TODO: improve?
    if options[:body].is_a?(Hash) || options[:body].is_a?(Array)
      options[:body] = options[:body].to_json
    end

    r = HTTParty.send verb, "#{url}#{endpoint}", options
    if r.code >= 400 && r.code < 600
      raise "There was an error (#{r.code}) - #{r}"
    end
    r
  end
end



api = MyApi.new Url
# api = MyApi.new "http://localhost:4567"

#HTTParty.get("http://localhost:4567/events", headers: { "Authorization" => "zadf:3456"} )



binding.pry

#until exit_program

  puts "Welcome to event planner."
  api.login_as "zdh", "tpt345"




# puts "~MAIN MENU~~~~~~~~~~~~~~~~~~"

# puts "\n\t1. Log in"
# puts "\n\t2. Create new account"
# puts "\n\t2. Exit"
# gets ": "

# puts "\n\t1. Log out"
# puts "\n\t2. View events"
# puts "\n\t3. Exit"

# puts "\n\t1. Add event"
# puts "\n\t2. Edit event"
# puts "\n\t3. Delete event"
# puts "\n\t4. Return to Main Menu"

# Add Event Menu

# puts "Please provide a name for the event"
# puts "Please enter the data for the event (YYYY-MM-DD): "
# puts "Please enter a time for the event (hh:mm): "
# puts "Please enter the duration of the event (hh:mm): "

# Edit Event Menu

# 1. Edit title
# 2. Edit date
# 3. Edit time
# 4. Edit duration
# 5. Save Changes and Return to Menu

# Delete Event

# Are you sure you want to delete the event?
