require './test/helpers/unit_helper.rb'
require './lib/app'
require './lib/sinatra/auth'

class IdeaBoxAuthTest < Minitest::Test
  include Rack::Test::Methods

  # def setup
  #   IdeaStore.filename = 'db/test'
  # end

  # def teardown
  #   IdeaStore.delete_all
  # end

  def app
    @app ||= IdeaBoxApp.new
  end

  def test_the_get_login_method_returns_the_login_page
    get '/session/login'
    assert last_response.body.include?("Username:")
  end

  def test_the_get_logout_method_redirects_to_the_root
    get '/session/logout'
    assert_equal 302, last_response.status
  end

end