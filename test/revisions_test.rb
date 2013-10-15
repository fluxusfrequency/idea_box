gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/idea_store.rb'
require_relative '../lib/idea_box/idea.rb'

class RevisionsTest < Minitest::Test

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

  def test_it_can_edit_ideas
    idea = IdeaStore.create({
      'id' => 1,
      'title' => "Love Life",
      'description' => "Watching movies alone at home",
      'tags' => 'love',
      })
    sleep(1)
    IdeaStore.update(1, 'title' => 'Friday Night')
    assert_equal 'Friday Night', IdeaStore.find(1).title
    assert_equal 2, IdeaStore.find(1).revision
    refute_equal IdeaStore.find(1).created_at, IdeaStore.find(1).updated_at
  end

end