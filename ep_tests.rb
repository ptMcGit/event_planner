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
      response = get "/list"
      assert_equal 401, response.status

      body = JSON.parse response.body
      binding.pry
      assert_equal "You must log in.", body["error"]
    end
  end
end
