gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea_store.rb'
require_relative '../lib/idea_box/idea.rb'

class TaggingTest < Minitest::Test

  def setup
    IdeaStore.set_test
  end

#   def teardown
#     file = File.open('./db/test', 'w+')
#     file <<
# "---
# ideas:
# - id: 1
#   title: Diet
#   description: Pizza all day
#   tags: 'food'
# "
#   end

  def test_it_can_create_and_find_ideas
    assert IdeaStore.create({
      "id" => 1,
      "title" => "Diet",
      "description" => "Pizza all the time",
      })
    assert_kind_of Idea, IdeaStore.find(1)
  end

  def test_it_can_create_and_find_ideas_with_tags
    assert IdeaStore.create({
      "id" => 2,
      "title" => "Diet",
      "description" => "Pizza all the time",
      "tags" => "food, diet"
      })
    assert_kind_of Array, IdeaStore.find_all_by_tags('food', 'diet')
    # assert_kind_of Idea, IdeaStore.find_all_by_tags('food', 'diet').first
    # assert_kind_of Array, IdeaStore.find_all_by_tags('food')
    # assert_kind_of Idea, IdeaStore.find_all_by_tags('food').first
  end

  def test_it_can_sort_ideas_by_tags
    assert_kind_of Hash, IdeaStore.group_all
  end

end