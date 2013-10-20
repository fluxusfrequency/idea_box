require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class PortfolioTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
    RevisionStore.filename = 'db/test_revisions'
  end

  def teardown
    IdeaStore.delete_all
    RevisionStore.delete_all
  end

  def test_it_exists
    assert User
  end

  def test_it_can_set_up_attrs
    user = User.new({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'password',
      'email'        => 'bennlewis@gmail.com',
      'porfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    assert_respond_to user, :id
    assert_respond_to user, :username
    assert_respond_to user, :password
    assert_respond_to user, :email
    assert_respond_to user, :portfolios
    assert_respond_to user, :created_at
  end

end