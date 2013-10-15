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
# # "---
# # ideas:
# # - id: 1
# #   title: Eat
# #   description: Pizza all day"
#   end

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

end