gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea_store.rb'
require_relative '../lib/idea_box/idea.rb'

class GroupedIdeasTest < Minitest::Test

  def setup
    IdeaStore.set_test
    IdeaStore.delete_all
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_ideas_are_grouped_by_work_by_default
    idea = IdeaStore.create({
      "id" => 1,
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love"
      })
    assert_equal 'work', IdeaStore.find(1).group
  end

  def test_ideas_can_be_created_with_other_groups_than_work
    idea = IdeaStore.create({
      "id" => 2,
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love",
      "group" => "home"
      })
    assert_equal 'home', IdeaStore.find(2).group
  end

  def test_the_idea_store_can_return_ideas_grouped_by_group
    idea_3 = IdeaStore.create({
      "id" => 3,
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love",
      "group" => "monkey"
      })
    idea_4 = IdeaStore.create({
      "id" => 4,
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love",
      "group" => "monkey"
      })
    assert_equal 2, IdeaStore.find_all_by_group("monkey").length
  end

  def test_an_idea_can_only_belong_to_a_single_group
    idea_5 = IdeaStore.create({
      "id" => 5,
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love",
      "group" => "giraffe, elephant"
      })
    assert_equal "giraffe", IdeaStore.find(5).group
  end

  def test_when_sorting_by_rank_it_only_shows_ideas_in_same_group
    idea_6 = IdeaStore.create({
      "id" => 6,
      "title" => "Hunger",
      "description" => "I love chocolate",
      "tags" => "food",
      "group" => "chocolate"
      })
    idea_7 = IdeaStore.create({
      "id" => 7,
      "title" => "Dessert",
      "description" => "I love ice cream",
      "tags" => "food",
      "rank" => 2,
      "group" => "chocolate"
      })
    assert_equal 7, IdeaStore.sort_by_rank("chocolate").first.id
  end

  def test_when_sorting_by_id_it_only_shows_ideas_in_same_group
    idea_8 = IdeaStore.create({
      "id" => 8,
      "title" => "Hunger",
      "description" => "I love chocolate",
      "tags" => "food",
      "group" => "chocolate"
      })
    idea_9 = IdeaStore.create({
      "id" => 9,
      "title" => "Dessert",
      "description" => "I love ice cream",
      "tags" => "food",
      "rank" => 2,
      "group" => "chocolate"
      })
    assert_equal 8, IdeaStore.sort_by_id("chocolate").first.id
  end

end