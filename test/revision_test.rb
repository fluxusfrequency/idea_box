gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/idea_box/revision.rb'
require_relative '../lib/idea_box/revision_store.rb'
require_relative '../lib/idea_box/idea.rb'
require_relative '../lib/idea_box/idea_store.rb'

class RevisionTest < Minitest::Test

  def setup
    RevisionStore.filename = 'db/test_revisions'
  end

  def teardown
    RevisionStore.delete_all
  end

  def test_it_can_set_up_attrs
    revision = RevisedIdea.new({
      'id' => 1,
      'idea_id' => 1,
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => Time.now,
      'updated_at' => Time.now,
      'revision' => 1,
      'resources' => 'http://www.bikes.com'
      })
    assert_respond_to revision, :id
    assert_respond_to revision, :idea_id
    assert_respond_to revision, :title
    assert_respond_to revision, :description
    assert_respond_to revision, :tags
    assert_respond_to revision, :created_at
    assert_respond_to revision, :updated_at
    assert_respond_to revision, :revision
    assert_respond_to revision, :resources
  end

  def test_it_can_populate_default_attrs
    revision = RevisedIdea.new
    assert_respond_to revision, :id
    assert_respond_to revision, :idea_id
    assert_respond_to revision, :title
    assert_respond_to revision, :description
    assert_respond_to revision, :tags
    assert_respond_to revision, :created_at
    assert_respond_to revision, :updated_at
    assert_respond_to revision, :revision
    assert_respond_to revision, :resources
    assert_equal 0, revision.idea_id
  end

  def test_it_can_be_created_from_an_idea
    idea = Idea.new({
          'id' => 2,
          'title' => "Transportation",
          'description' => "Bicycles and busses",
          'tags' => 'bike, bus',
          'created_at' => Time.now,
          'updated_at' => Time.now,
          'revision' => 1,
          'group' => 'home',
          'resources' => ['http://www.bikes.com']
          })
    sleep(1)
    revision = RevisedIdea.new(idea.to_h.merge('id' => 1, 'idea_id' => idea.id))
    assert_equal 1, revision.id
    assert_equal 2, revision.idea_id
    assert_equal "Transportation", revision.title
    assert_equal "Bicycles and busses", revision.description
    assert_equal idea.created_at, revision.created_at
    refute_equal idea.updated_at, revision.updated_at
    assert_equal 1, revision.revision
    refute_respond_to revision, :group
    assert_equal 'http://www.bikes.com', revision.resources.first
  end

end