require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class UserTest < Minitest::Test

  def setup
    IdeaStore.filename = 'db/test'
    RevisionStore.filename = 'db/test_revisions'
    UserStore.filename = 'db/test_users'
  end

  def teardown
    IdeaStore.delete_all
    RevisionStore.delete_all
    UserStore.delete_all
  end

  def test_it_exists
    assert User
    assert UserStore
  end

  def test_it_can_set_up_attrs
    user = User.new({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'password',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    assert_respond_to user, :id
    assert_respond_to user, :username
    assert_respond_to user, :password
    assert_equal 'bennlewis@gmail.com', user.email
    assert_respond_to user, :portfolios
    assert_respond_to user, :created_at
  end

  def test_it_can_populate_default_attrs
    user = User.new
    assert_respond_to user, :id
    assert_respond_to user, :username
    assert_equal Digest::MD5.hexdigest('password'), user.password
    assert_respond_to user, :email
    assert_respond_to user, :portfolios
    assert_respond_to user, :created_at
  end

  def test_the_user_store_can_create_new_users
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'password',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
  end

  def test_the_user_store_can_find_a_user
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'password',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    assert_equal 'bennlewis@gmail.com', UserStore.find(1).email
  end

  def test_the_user_store_can_update_a_user
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'password',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    UserStore.update(1, "username" => "benito")
    assert_equal 'benito', UserStore.find(1).username
  end

  def test_the_user_store_can_delete_a_user
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      "password"     => 'password',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    assert_equal 'ben', UserStore.find(1).username
    UserStore.delete(1)
    assert_equal 0, UserStore.all.size
  end

  def test_the_user_store_can_list_a_users_portfolios
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    assert_equal 3, UserStore.find_portfolios_for_user(1).keys.length
  end

end