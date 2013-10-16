gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea_store.rb'
require_relative '../lib/idea_box/idea.rb'

class TaggingTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_it_can_create_and_find_ideas
    assert IdeaStore.create({
      "id" => 1,
      "title" => "Diet",
      "description" => "Pizza all the time",
      })
    assert_kind_of Idea, IdeaStore.find(1)
  end

  def test_it_can_create_and_find_ideas_with_tags
    IdeaStore.create({
      "id" => 2,
      "title" => "Diet",
      "description" => "Pizza all the time",
      "tags" => "food, diet"
      })
    assert_kind_of Array, IdeaStore.find_all_by_tags('food', 'diet')
    assert_kind_of Idea, IdeaStore.find_all_by_tags('food', 'diet').first
    assert_kind_of Array, IdeaStore.find_all_by_tags('food')
    assert_kind_of Idea, IdeaStore.find_all_by_tags('food').first
    assert_kind_of Array, IdeaStore.find_all_by_tags('diet')
    assert_kind_of Idea, IdeaStore.find_all_by_tags('diet').first
  end

  def test_it_can_sort_ideas_by_tags
    IdeaStore.create({
      "title" => "Diet",
      "description" => "Pizza all the time",
      "tags" => "food, diet"
      })
    IdeaStore.create({
      "title" => "Beverages",
      "description" => "Beer all the time",
      "tags" => "diet"
      })
    IdeaStore.create({
      "title" => "BBQ",
      "description" => "Beer and BBQ",
      "tags" => "food, fun"
      })
    assert 1, IdeaStore.sort_all_by_tags['fun'].length
    assert 2, IdeaStore.sort_all_by_tags['diet'].length
    assert 2, IdeaStore.sort_all_by_tags['food'].length
  end

end