require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class UserTest < Minitest::Test

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
      'portfolios'   => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'phone'        => '7192907974',
      'created_at'   => Time.now
      })
    assert_respond_to user, :id
    assert_respond_to user, :username
    assert_respond_to user, :password
    assert_equal 'bennlewis@gmail.com', user.email
    assert_respond_to user, :portfolios
    assert_respond_to user, :phone
    assert_respond_to user, :created_at
  end

  def test_it_can_populate_default_attrs
    user = User.new
    assert_respond_to user, :id
    assert_respond_to user, :username
    assert_equal Digest::MD5.hexdigest('password'), user.password
    assert_respond_to user, :email
    assert_respond_to user, :portfolios
    assert_respond_to user, :phone
    assert_respond_to user, :created_at
  end

  def test_it_can_clean_phone_numbers
    user = User.new({'phone' => '7192907974'})
    assert_equal '7192907974', user.phone
  end

  def test_it_can_load_its_idea_db
    user = User.new
    user.load_ideas
    assert_equal "db/user/#{user.id}_ideas", IdeaStore.filename
  end

  def test_it_can_load_its_revisions_db
    user = User.new
    user.load_revisions
    assert_equal "db/user/#{user.id}_revisions", RevisionStore.filename
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
    assert UserStore.all.length == 1
    assert_equal 'ben', UserStore.find(1).username
  end

  def test_the_user_store_can_create_new_users_with_only_some_attrs
    UserStore.create({
      'username'     => 'ben',
      'password'     => 'hello',
      'email'        => 'bennlewis@gmail.com',
      })
    
    assert UserStore.all.length == 1
    user = UserStore.find(1)
    assert_equal 1, user.id
    assert_equal 'ben', user.username
    # assert_equal Digest::MD5.hexdigest('hello'), user.password
    assert_equal 'bennlewis@gmail.com', user.email
    assert_kind_of Hash, user.portfolios
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

  def test_the_user_store_loads_a_users_databases_upon_creation
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    assert_equal 'db/user/1_ideas', IdeaStore.filename
    assert_equal 'db/user/1_revisions', RevisionStore.filename
  end

  def test_the_user_store_has_a_load_users_databases_method
    UserStore.create({
      'id'           => 1,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    UserStore.load_databases_for(1)
    assert_equal 'db/user/1_ideas', IdeaStore.filename
    assert_equal 'db/user/1_revisions', RevisionStore.filename
  end


end