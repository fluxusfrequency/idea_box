require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class StatisticsTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_it_can_show_ideas_broken_down_by_hour_of_day
    IdeaStore.create({
      'id' => 3,
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => Time.now.to_s
      })
    IdeaStore.create({
      'id' => 4,
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'created_at' => Time.now.to_s
      })
    assert IdeaStore.group_all_by_time_created
  end

  def test_it_can_show_ideas_broken_down_day_of_the_week
    IdeaStore.create({
      'id' => 5,
      'title' => "Water",
      'description' => "Drink from the creek",
      'tags' => 'giardia',
      'created_at' => Time.now
      })
    IdeaStore.create({
      'id' => 6,
      'title' => "Monday",
      'description' => "Pancakes for breakfast",
      'tags' => 'obesity',
      'created_at' => Time.now
      })
    assert_kind_of Hash, IdeaStore.group_all_by_day_created
  end

end