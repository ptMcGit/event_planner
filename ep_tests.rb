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

  # user authorization headers

  def admin_user
    ["Authorization", "ronswanson76:monkey25"]
  end

  def reg_user
    ["Authorization", "mallory:ilikedogs45"]
  end

  # event use cases

  def socal_reggae
    {
      title: "Reggae Sunsplash",
      date: "2015-06-17",
      zip_code: "90210"
    }
  end

  def rainy_birthday
    {
      title: "Bob birthday",
      date: "2015-06-16",
      zip_code: "98101"
    }
  end

  def local_interview
    {
      title: "Job interview",
      date: "2016-07-12",
      zip_code: "27401"
    }
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

      binding.pry
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
      post "/events", rainy_birthday
      post "/events", socal_reggae

      response = get "/events"

      assert_equal 200, response.status

      list = JSON.parse response.body
      assert_equal 2, list.count

      assert_equal "Bob birthday", list.first["title"]
      assert_equal "2015-06-16", list.first["date"]
    end

    def test_can_delete_event
      header "Authorization", "delete_event_test"
      post "/events", title: "Sue birthday", date: "2015-06-16", zip_code: "68805"
      post "/events", title: "Bonnaroo", date: "2015-06-17", zip_code: "34456"

      delete "/events", title: "Sue birthday"

      response = get "/events"

      list = JSON.parse response.body
      assert_equal 1, list.count
    end

    def test_cannot_add_duplicate_event
      r1 = post "/events", rainy_birthday
      r2 = post "/events", rainy_birthday

      body = JSON.parse r2.body

      assert_equal "error", body["status"]
    end

  end
end
