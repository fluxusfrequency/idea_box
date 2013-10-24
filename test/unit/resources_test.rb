require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class ResourcesTest < Minitest::Test

  def teardown
    IdeaStore.delete_all
  end

  def test_it_can_persist_a_resource_attr
    IdeaStore.create({
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'resources' => "www.bike.com"
      })
    assert_equal ["www.bike.com"], IdeaStore.find_all_by_tags("bus").first.resources
  end

  def test_it_can_persist_two_resources
    IdeaStore.create({
      'title' => "Hunger",
      'description' => "Pizza and chocolate",
      'tags' => 'pizza, chocolate',
      'resources' => ["www.dominos.com", "www.hersheys.com"]
      })
    assert_equal ["www.dominos.com", "www.hersheys.com"], IdeaStore.find_all_by_tags("pizza").first.resources
  end

  def test_idea_store_can_find_by_resources
    IdeaStore.create({
      'id'          => 1,
      'title'       => "Holiness",
      'description' => "Pope on a rope",
      'tags'        => 'vatican',
      'resources'   => ["www.god.com", "the bible"]
      })
    assert_equal ["www.god.com", "the bible"], IdeaStore.find_resources_for_idea(1)
  end

end