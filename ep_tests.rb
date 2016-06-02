require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'

require "./app"

class EventPlannerBase < Minitest::Test
  include Rack::Test::Methods

  def app
    EventPlanner
  end

  class NotLoggedIn < EventPlannerBase
    def test_login_is_required
      response = get "/events"
      assert_equal 401, response.status

      body = JSON.parse response.body
      assert_equal "You must log in.", body["error"]
    end
  end

  class LoggedIn < EventPlannerBase

    def setup
      super
      header "Authorization", "zachh"
    end

    focus

    def test_starts_with_empty_list
      header "Authorization", "empty_user_test"
      response = get "/events"

      assert_equal 200, response.status
      assert_equal "[]", response.body
    end

    def test_starts_with_empty_list
      response = get "/events"

      assert_equal 200, response.status
      assert_equal "[]", response.body
    end

    def test_can_add_event
      post "/events", title: "Bob birthday", date: "2015-06-16"
      post "/events", title: "Reggae Sunsplash", date: "2015-06-17"

      response = get "/events"

      assert_equal 200, response.status

      list = JSON.parse response.body
      assert_equal 2, list.count
      assert_equal "Bob birthday", list.first["title"]
      assert_equal "2015-06-16", list.first["date"]
    end





  end


  # def test_it_can_store_events
  #   r = get "/events"

  #   assert_equal 200, response.status
  #   assert_equal "[]", response.body

  #   post "/events", title: "My First Event"

  #   r = get "/events"
  #   assert_equal 200, response.status
  #   assert_equal "My First Event", JSON.parse(response.body)
  # end




end
