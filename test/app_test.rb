gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
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
    get '/all/exercise'
    assert_equal 200, last_response.status
  end

end