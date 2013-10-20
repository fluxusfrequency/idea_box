require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class IdeaTest < Minitest::Test

  def test_it_can_set_up_attrs
    idea = Idea.new({
      'id' => 1,
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => Time.now,
      'updated_at' => Time.now,
      'revision' => 1,
      'group' => 'home',
      'resources' => 'http://www.bikes.com'
      })
    assert_respond_to idea, :id
    assert_respond_to idea, :title
    assert_respond_to idea, :description
    assert_respond_to idea, :rank
    assert_respond_to idea, :tags
    assert_respond_to idea, :created_at
    assert_respond_to idea, :updated_at
    assert_respond_to idea, :revision
    assert_respond_to idea, :group
    assert_respond_to idea, :resources
  end

  def test_it_can_populate_default_attrs
    idea = Idea.new
    assert_respond_to idea, :id
    assert_respond_to idea, :title
    assert_respond_to idea, :description
    assert_respond_to idea, :rank
    assert_respond_to idea, :tags
    assert_respond_to idea, :created_at
    assert_respond_to idea, :updated_at
    assert_respond_to idea, :revision
    assert_respond_to idea, :group
    assert_respond_to idea, :resources
  end

end