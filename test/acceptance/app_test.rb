require './test/helpers/acceptance_helper'
require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class IdeaBoxAppTest < Minitest::Test
  include Rack::Test::Methods
  include Capybara::DSL

 def setup
    visit '/'
    fill_in("username", :with => 'admin')
    fill_in("password", :with => 'password')
    click_on 'Log In'
    click_on 'Profile'
    fill_in('new_portfolio', :with => 'Zanzibar')
    click_on 'Create New'
    visit '/'
    click_on 'Zanzibar'
  end

  def teardown
    visit '/'
    click_on 'Profile'
    within '#Zanzibar_delete' do
      click_on 'Delete'
    end
    within("#logout") do
      click_on 'Log Out'
    end
  end

  def create_stub
    visit '/'
    click_on 'new_idea'
    fill_in('idea[title]', :with => 'test_edit')
    fill_in('idea[description]', :with => 'test_body')
    click_on 'Submit'
  end

  def app
    @app ||= IdeaBoxApp.new
  end

  def test_it_exists
    visit '/'
    assert page.has_content?("New Idea")
  end

  def test_create_new_idea
    visit '/'
    click_on 'new_idea'
    fill_in('idea[title]', :with => 'Capybara') 
    fill_in('idea[description]', :with => 'Let robots visit my website.') 
    fill_in('idea[tags]', :with => 'tdd')
    fill_in('idea[resources]', :with => 'Capybara')
    click_on 'Submit'
    assert page.has_content?("Tags: tdd")
  end

  def test_create_empty_idea
    visit '/'
    click_on 'new_idea'
    fill_in('idea[title]', :with => '') 
    fill_in('idea[description]', :with => '') 
    fill_in('idea[tags]', :with => '')
    fill_in('idea[resources]', :with => '')
    click_on 'Submit'
    assert page.has_content?("Tags: ")
  end

  def test_view_idea
    create_stub
    visit '/'
    click_on 'test_edit'
    assert page.has_content?("Viewing: test")
  end

  def test_edit_idea
    create_stub
    visit '/'
    click_on 'test_edit_panel'
    assert page.has_content?("Editing - test_edit")
    fill_in('idea[description]', :with => 'Hello, world!')
    click_on 'Submit'
    visit '/'
    assert page.has_content?("Hello, world!")
  end

  def test_liking_an_idea
    create_stub
  end

  # def test_it_shows_an_idea
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes"}}
  #   get '/1'
  #   assert_equal 200, last_response.status
  # end

  # def test_it_shows_all_ideas_with_a_given_tag
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", tags: "exercise"}}
  #   post '/', {idea: {title: "running", description: "jog before work", tags: "exercise"}}
  #   get '/all/tags/exercise'
  #   assert last_response.body.include?("All Ideas Tagged With: exercise")
  # end

  # def test_it_shows_all_ideas_sorted_by_tag
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", tags: "exercise"}}
  #   post '/', {idea: {title: "running", description: "jog before work", tags: "exercise"}}
  #   post '/', {idea: {title: "work", description: "computers", tags: "job"}}
  #   post 'search/tags/results'
  #   assert last_response.body.include?("All Ideas Sorted By Tag")
  # end

  # def test_it_shows_all_ideas_sorted_by_day
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", created_at:
  #     "2013-10-15 18:57:50 -0600" }}
  #   post '/', {idea: {title: "running", description: "jog before work", created_at: "2013-10-14 18:57:50 -0600"}}
  #   post '/', {idea: {title: "work", description: "computers", created_at: "2013-10-15 18:58:50 -0600"}}
  #   post '/search/day/results'
  #   assert last_response.body.include?("All Ideas Sorted By Day")
  # end

  # def test_it_shows_a_page_for_search
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", created_at:
  #         "2013-10-15 18:57:50 -0600" }}
  #   post '/search/results', {search_text: "Beer!"}
  #   assert last_response.body.include?("You searched for:")
  #   assert last_response.body.include?("Beer!")

  # end

  # def test_it_shows_a_page_for_time_search
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", created_at:
  #         "2013-10-15 18:57:50 -0600" }}
  #   post '/search/time/results', {time_range: "1:00PM-1:45PM"}
  #   assert last_response.body.include?("All Ideas Created Between")
  # end

end