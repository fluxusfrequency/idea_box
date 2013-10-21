require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class RevisionTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
    RevisionStore.filename = 'db/test_revisions'
  end

  def teardown
    IdeaStore.delete_all
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
      'resources' => 'http://www.bikes.com'
      })
    assert_respond_to revision, :id
    assert_respond_to revision, :idea_id
    assert_respond_to revision, :title
    assert_respond_to revision, :description
    assert_respond_to revision, :tags
    assert_respond_to revision, :created_at
    assert_respond_to revision, :updated_at
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
          'group' => 'home',
          'resources' => ['http://www.bikes.com']
          })
    sleep(1)
    revision = RevisionStore.create(idea.to_h.merge('id' => 1, 'idea_id' => idea.id))
    assert_equal 1, revision.id
    assert_equal 2, revision.idea_id
    assert_equal "Transportation", revision.title
    assert_equal "Bicycles and busses", revision.description
    assert_equal idea.created_at, revision.created_at
    refute_equal idea.updated_at, revision.updated_at
    assert_equal 1, revision.revision
    refute_respond_to revision, :group
    refute_respond_to revision, :rank
    assert_equal 'http://www.bikes.com', revision.resources.first
  end

  def test_the_revision_actually_revises_content
    idea = Idea.new({
      'title' => "Recreation",
      'description' => "Bicycles In The Park",
      'tags' => 'bike',
      })
    revision = RevisedIdea.new(idea.to_h.merge('idea_id' => idea.id, 'description' => 'Motorcycles in the park'))
    assert_equal "Motorcycles in the park", revision.description
  end

  def test_the_revision_store_can_find_all_by_idea_id
    idea = Idea.new({
      'title' => "Recreation",
      'description' => "Bicycles In The Park",
      'tags' => 'bike',
      })
    revision_1 = RevisionStore.create(idea.to_h.merge('idea_id' => idea.id, 'description' => 'Motorcycles in the park'))
    revision_2 = RevisionStore.create(idea.to_h.merge('idea_id' => idea.id, 'description' => 'Monster trucks in the park'))
    assert_equal 2, RevisionStore.find_all_by_idea_id(1).length
    assert_equal 'Monster trucks in the park', RevisionStore.find_all_by_idea_id(1).last.description
    RevisionStore.delete_all
  end

  def test_new_revisions_have_an_incrementing_revision_count
    idea = Idea.new({
      'title' => "Recreation",
      'description' => "Bicycles In The Park",
      'tags' => 'bike',
      })
    revision_1 = RevisionStore.create(idea.to_h.merge('idea_id' => idea.id, 'description' => 'Motorcycles in the park'))
    assert_equal 1, RevisionStore.find_all_by_idea_id(idea.id).length
    assert_equal 1, RevisionStore.find_all_by_idea_id(idea.id).first.revision
    revision_2 = RevisionStore.create(idea.to_h.merge('idea_id' => idea.id, 'description' => 'Monster trucks in the park'))
    assert_equal 2, RevisionStore.find_all_by_idea_id(idea.id).length
    assert_equal 2, RevisionStore.find_all_by_idea_id(idea.id).last.revision
  end

  def test_the_idea_store_creates_a_new_revision_when_an_idea_is_updated
    idea = Idea.new({
      'title' => "Recreation",
      'description' => "Bicycles In The Park",
      'tags' => 'bike',
      })
    IdeaStore.update(idea.id, idea.to_h.merge("description" => "Motorcycles in the park"))
    IdeaStore.update(idea.id, idea.to_h.merge("description" => "Alligators in the park"))
    assert_equal 2, RevisionStore.find_all_by_idea_id(idea.id).length
  end

  def test_it_can_destroy_all_db_entries
    idea = IdeaStore.create({
      "id" => 3,
      "title" => "Hobbies",
      "description" => "Mountain Biking",
      "tags" => "exercise"
      })
    IdeaStore.delete_all
    assert_equal 0, IdeaStore.all.count
  end

  def test_it_can_edit_ideas
    idea = IdeaStore.create({
      "id" => 1,
      "title" => "Love Life",
      "description" => "Watching movies alone at home",
      "tags" => "love"
      })
    sleep(1)
    IdeaStore.update(1, 'title' => 'Friday Night')
    assert_equal 'Friday Night', IdeaStore.find(1).title
    assert_equal 1, IdeaStore.find(1).revision
    refute_equal IdeaStore.find(1).created_at, IdeaStore.find(1).updated_at
  end

end