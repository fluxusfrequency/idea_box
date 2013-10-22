require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class SearchingTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_it_can_search_for_ideas_between_hours_of_the_day
    IdeaStore.create({
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    IdeaStore.create({
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'created_at' => "2013-10-17 10:29:00 -0600"
      })
    time_range = ["10:00AM", "10:45AM"]
    assert_equal 2, IdeaStore.find_all_by_time_created(time_range[0], time_range[1]).length
    assert_kind_of Idea, IdeaStore.find_all_by_time_created(time_range[0], time_range[1]).first
  end

  def test_it_can_search_for_ideas_with_title_description_or_tags
    IdeaStore.create({
      'title' => "Recreation",
      'description' => "Bicycles In The Park",
      'tags' => 'bike',
      })
    IdeaStore.create({
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      })
    assert_equal 2, IdeaStore.search_for("park").length
    assert_kind_of Idea, IdeaStore.search_for("Gerschwin").first
  end

end