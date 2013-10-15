gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea_store.rb'
require_relative '../lib/idea_box/idea.rb'

class TaggingTest < Minitest::Test

  def setup
    IdeaStore.set_test
  end


  def teardown
    file = File.open('./db/test', 'w+')
    file << "---
ideas:
- id: 37
  title: Transporation
  description: Bicycles and busses
  tags: bike, bus
  rank: 0
  created_at: 2013-10-15 06:30:51.000000000 -06:00
  updated_at: 2013-10-15 06:30:51.000000000 -06:00
  revision: 1"
  end

  def test_it_can_show_ideas_broken_down_by_hour_of_day
    IdeaStore.create({
      'id' => 3,
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => Time.now
      })
    IdeaStore.create({
      'id' => 4,
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'created_at' => Time.now
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