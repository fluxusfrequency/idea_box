gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea.rb'

class IdeaTest < Minitest::Test

  def setup
  end

  def test_it_can_set_up_params
    idea = Idea.new({
      'id' => 1,
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => Time.now
      })
    assert_respond_to idea, :id
    assert_respond_to idea, :title
    assert_respond_to idea, :description
    assert_respond_to idea, :rank
    assert_respond_to idea, :tags
    assert_respond_to idea, :created_at
  end

end