require './test/helpers/acceptance_helper.rb'
require './test/helpers/unit_helper.rb'
require './lib/idea_box'
require './lib/app'

class IdeaBoxAppTest < Minitest::Test
  include Capybara::DSL

  def setup
    UserStore.create({
      "id" => 99,
      "username" => "bilbo",
      "password" => Digest::MD5.hexdigest("baggins"),
      "email" => "jane@example.com",
      "portfolios" =>
        { 1 => "work",
        2 => "Beer!",
        6 => "texts" },
      "phone" => "7192907974",
      "created_at" => '2013-10-20 20:14:54 -0600'})
    visit '/'
    fill_in("username", :with => 'bilbo')
    fill_in("password", :with => 'baggins')
    click_on 'Log In'
    create_stub_idea
  end

  def teardown
    visit '/'
    within("#logout") do
      click_on 'Log Out'
    end
    UserStore.delete_all
    IdeaStore.delete_all
    RevisionStore.delete_all
  end

  def create_stub_idea
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
    visit '/'
    click_on 'test_edit_title'
    assert page.has_content?("Viewing: test_edit")
  end

  def test_edit_idea
    visit '/'
    click_on 'test_edit_panel'
    assert page.has_content?("Editing - test_edit")
    fill_in('idea[description]', :with => 'Hello, world!')
    click_on 'Submit'
    visit '/'
    assert page.has_content?("Hello, world!")
  end

end