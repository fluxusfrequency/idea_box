
gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'sinatra'
require 'sinatra/assetpack'
require 'rack/test'
require_relative '../lib/app'

class IdeaBoxAppTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    IdeaStore.filename = 'db/test'
  end

  def teardown
    IdeaStore.delete_all
  end

  def app
    @app ||= IdeaBoxApp.new
  end

  def test_the_get_root_method_returns_the_index
    get '/'
    assert_equal 200, last_response.status
  end

  def test_create_new_idea
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes"}}
    idea = IdeaStore.all.first
    assert_equal "exercise", idea.title
    assert_equal "sign up for stick fighting classes", idea.description
  end

  def test_edit_idea_by_id
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes"}}
    get '/1/edit'
    assert_equal 200, last_response.status
  end

  def test_edit_idea_by_id
    post '/1', {idea: { title: "exercise", description: "sign up for stick fighting classes"}}
    put '/1', {idea: { title: "exercise", description: "sign up for capoeria classes"}}
    assert_equal "sign up for capoeria classes", IdeaStore.find(1).description
    assert_equal 302, last_response.status
  end

  # def test_delete_idea_by_id
  #   post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes"}}
  #   delete '/1'
  #   assert_equal nil, IdeaStore.find(1)
  #   assert_equal 302, last_response.status
  # end

  def test_liking_an_idea
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes"}}
    post '/1/like'
    assert_equal 1, IdeaStore.find(1).rank
    assert_equal 302, last_response.status
  end

  def test_it_shows_an_idea
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes"}}
    get '/1'
    assert_equal 200, last_response.status
  end

  def test_it_shows_all_ideas_with_a_given_tag
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", tags: "exercise"}}
    post '/', {idea: {title: "running", description: "jog before work", tags: "exercise"}}
    get '/all/tags/exercise'
    assert last_response.body.include?("All Ideas Tagged With: exercise")
  end

  def test_it_shows_all_ideas_sorted_by_tag
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", tags: "exercise"}}
    post '/', {idea: {title: "running", description: "jog before work", tags: "exercise"}}
    post '/', {idea: {title: "work", description: "computers", tags: "job"}}
    get '/all/tags'
    assert last_response.body.include?("All Ideas (Sorted By Tag)")
  end

  def test_it_shows_all_ideas_sorted_by_day
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", created_at:
      "2013-10-15 18:57:50 -0600" }}
    post '/', {idea: {title: "running", description: "jog before work", created_at: "2013-10-14 18:57:50 -0600"}}
    post '/', {idea: {title: "work", description: "computers", created_at: "2013-10-15 18:58:50 -0600"}}
    get '/all/day'
    assert last_response.body.include?("All Ideas (Sorted By Day)")
  end

  def test_it_shows_a_page_for_search
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", created_at:
          "2013-10-15 18:57:50 -0600" }}
    post '/search/results', {search_text: "Beer!"}
    assert last_response.body.include?("You searched for:")
    assert last_response.body.include?("Beer!")

  end

  def test_it_shows_a_page_for_time_search
    post '/', {idea: {title: "exercise", description: "sign up for stick fighting classes", created_at:
          "2013-10-15 18:57:50 -0600" }}
    post '/search/time/results', {time_range: "1:00PM-1:45PM"}
    assert last_response.body.include?("All Ideas Created Between")
  end

end