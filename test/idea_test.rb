gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea.rb'
require_relative '../lib/idea_box/idea_store.rb'

class IdeaTest < Minitest::Test

  def setup
  end

  def test_it_can_set_up_attrs
    idea = Idea.new({
      'id' => 1,
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => Time.now,
      'updated_at' => Time.now,
      'revision' => 1
      })
    assert_respond_to idea, :id
    assert_respond_to idea, :title
    assert_respond_to idea, :description
    assert_respond_to idea, :rank
    assert_respond_to idea, :tags
    assert_respond_to idea, :created_at
    assert_respond_to idea, :updated_at
    assert_respond_to idea, :revision
  end

  def test_it_can_populate_default_attrs
    idea = Idea.new
    assert_respond_to idea, :id
    assert_respond_to idea, :title
    assert_respond_to idea, :description
    assert_respond_to idea, :rank
    assert_respond_to idea, :tags
    assert_respond_to idea, :created_at
    assert_respond_to idea, :updated_at
    assert_respond_to idea, :revision
  end

end