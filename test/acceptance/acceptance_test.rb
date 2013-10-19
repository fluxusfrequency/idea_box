require_relative '../helpers/acceptance_helper' # require the helper

class AcceptanceTest < Minitest::Test
  include Capybara::DSL

  def setup
    IdeaStore.filename = 'db/test'
    RevisionStore.filename = 'db/test_revisions'
  end

  def teardown
    IdeaStore.delete_all
    RevisionStore.delete_all
  end

  def test_it_exists
    visit '/'
    assert page.has_content?("Your Ideas")
  end

  # write your tests here

end