require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'

require "./app"

def valid_future_date
 Time.at(Time.now.tv_sec + rand(1..128000)).to_s.split(" ").first
end

# test events

Socal_reggae =
   {
     title: "Reggae Sunsplash",
     date: valid_future_date,
     zip_code: "90210"
   }

Rainy_birthday =
    {
      title: "Bob birthday",
      date: valid_future_date,
      zip_code: "98101"
    }

Expired_date_event =
    {
      title: "My forty-second birthday",
      date: "1991-04-12",
      zip_code: "27401"
    }

class EventPlannerBase < Minitest::Test
  include Rack::Test::Methods

  def app
    EventPlanner
  end

  # user authorization headers

  def admin_user
    ["Authorization", "ronswanson76:monkey25"]
  end

  def reg_user
    ["Authorization", "mallory:ilikedogs45"]
  end


  class AdminLogin < EventPlanner
    def test_no_special_access_reg_user
      header *reg_user
      response = get "/db"

      body = JSON.parse response.body

      assert_equal 403, response.status
      assert_equal 0, body.length
    end

    def test_admin_login_gets_special_access
      header *adminlogin
      response = get "/db"

      body = JSON.parse response.body

      assert_equal 200, response.status
    end
  end

  # class FirstTimeLogIn < EventPlannerBase
  #   def test_starts_with_empty_list
  #     header "Authorization", "empty_user_test"
  #     response = get "/events"

  #     assert_equal 200, response.status
  #     assert_equal "[]", response.body
  #   end

  class NotLoggedIn < EventPlannerBase
    def test_login_is_required
      response = get "/events"
      assert_equal 401, response.status

      body = JSON.parse response.body
      assert_equal "You must log in.", body["error"]
    end

    def test_no_special_access_no_user
      response = get "/db"
      body = JSON.parse response.body

      assert_equal 401, response.status
      assert_equal "error", body["status"]
    end
  end

  class LoggedIn < EventPlannerBase

    def setup
      super
      header *reg_user
    end


    def test_can_add_event
      post "/events", Rainy_birthday
      post "/events", Socal_reggae

      response = get "/events"
      assert_equal 200, response.status

      list = JSON.parse response.body
      binding.pry

      assert_equal 2, list.count

      assert_equal Rainy_birthday[:title], list.first["title"]
      assert_equal Rainy_birthday[:date], list.first["date"]
      assert_equal Rainy_birthday[:zip_code], list.first["zip_code"]
    end

    def test_can_delete_event
      header "Authorization", "delete_event_test"

      post "/events", Rainy_birthday
      post "/events", Socal_reggae

      delete "/events", title: Rainy_birthday[:title]

      response = get "/events"

      list = JSON.parse response.body

      assert_equal 1, list.count
    end

    def test_cannot_add_duplicate_event
      r1 = post "/events", Rainy_birthday
      r2 = post "/events", Rainy_birthday

      body = JSON.parse r2.body

      assert_equal "error", body["status"]
    end

    def test_cannot_add_event_in_past
      r1 = post "/events", Expired_date_event
      body = JSON.parse r1.body

      assert_equal "error", body["status"]
    end

#    def test_date_must_be_valid_calendar_date
#      assert_raises do
#        r = post "/events",
#             title: "My forty-second birthday",
#             date: "?xasf23",
#             zip_code: "27401"
#     end
#    end
  end
end
