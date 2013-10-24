require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class IdeaTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
    RevisionStore.filename = 'db/test_revisions'
  end

  def teardown
    IdeaStore.delete_all
    RevisionStore.delete_all
  end

  def test_it_can_set_up_attrs
    idea = Idea.new({
      'id'           => 1,
      'title'        => "Transporation",
      'description'  => "Bicycles and busses",
      'tags'         => 'bike, bus',
      'created_at'   => Time.now,
      'updated_at'   => Time.now,
      'portfolio_id' => 1,
      'uploads'      => 'this_is_how_we_do_it.mp3',
      'resources'    => 'http://www.bikes.com'
      })
    assert_respond_to idea, :id
    assert_respond_to idea, :title
    assert_respond_to idea, :description
    assert_respond_to idea, :rank
    assert_respond_to idea, :tags
    assert_respond_to idea, :created_at
    assert_respond_to idea, :updated_at
    assert_respond_to idea, :portfolio_id
    assert_respond_to idea, :uploads
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
    assert_respond_to idea, :portfolio_id
    assert_respond_to idea, :uploads
    assert_respond_to idea, :resources
  end

  def test_it_knows_its_revision_number
    idea = Idea.new
    assert_equal 0, idea.revision
  end

end