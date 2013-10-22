require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class PortfolioTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_ideas_are_given_a_the_current_portfolio_id_by_default
    IdeaStore.current_portfolio = 1
    IdeaStore.create({
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love"
      })
    assert_equal 1, IdeaStore.find(1).portfolio_id
  end

  def test_ideas_can_be_created_with_other_portfolio_ids_than_1
    IdeaStore.create({
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love",
      "portfolio_id" => 3
      })
    IdeaStore.current_portfolio = 3
    assert_equal 3, IdeaStore.find(1).portfolio_id
  end

  def test_the_idea_store_can_return_ideas_portfolio_ided_by_portfolio_id
    IdeaStore.create({
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love",
      "portfolio_id" => 1
      })
    IdeaStore.create({
      "title" => "Lover Life",
      "description" => "Eating popcorn at home alone",
      "tags" => "love",
      "portfolio_id" => 1
      })
    assert_equal 2, IdeaStore.find_all_by_portfolio_id(1).length
  end

  def test_an_idea_can_only_belong_to_a_single_portfolio_id
    IdeaStore.current_portfolio = 2
    idea = IdeaStore.create({
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love"
      })
    assert_equal 2, IdeaStore.find(idea.id).portfolio_id
    IdeaStore.change_portfolio_for_idea(idea.id, 3)
    IdeaStore.current_portfolio = 3
    assert_equal 3, IdeaStore.find(idea.id).portfolio_id
  end

  def test_when_sorting_by_rank_it_only_shows_ideas_in_same_portfolio_id
    IdeaStore.create({
      "title" => "Hunger",
      "description" => "I love chocolate",
      "tags" => "food",
      "portfolio_id" => 1
      })
    IdeaStore.create({
      "title" => "Dessert",
      "description" => "I love ice cream",
      "tags" => "food",
      "rank" => 2,
      "portfolio_id" => 1
      })
    IdeaStore.create({
      "title" => "Breakfast",
      "description" => "Bacon",
      "tags" => "food",
      "rank" => 2,
      "portfolio_id" => 2
      })
    assert_equal 2, IdeaStore.sort_portfolio_by_rank(1).first.id
  end

  def test_when_sorting_by_id_it_only_shows_ideas_in_same_portfolio_id
    IdeaStore.create({
      "title" => "Hunger",
      "description" => "I love chocolate",
      "tags" => "food",
      "portfolio_id" => 2
      })
    IdeaStore.create({
      "title" => "Dessert",
      "description" => "I love ice cream",
      "tags" => "food",
      "rank" => 2,
      "portfolio_id" => 2
      })
    IdeaStore.create({
      "title" => "Desserts",
      "description" => "I love ice cream!",
      "tags" => "food",
      "rank" => 3,
      "portfolio_id" => 3
      })
    assert_equal 2, IdeaStore.sort_by_portfolio_id(2).length
  end

end