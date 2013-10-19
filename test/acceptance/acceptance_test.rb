require_relative '../helpers/acceptance_helper' # require the helper

class AcceptanceTest < Minitest::Test
  include Capybara::DSL

  def test_it_exists
    visit '/'
    assert page.has_content?("Your Ideas")
  end

  # write your tests here

end