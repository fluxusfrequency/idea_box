require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class UsersPortfoliosTest < Minitest::Test

  def setup
    UserStore.filename = 'db/test_users'
  end

  def teardown
    IdeaStore.delete_all
    RevisionStore.delete_all
    UserStore.delete_all
  end

  def test_the_user_store_has_a_load_users_databases_method
    UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    UserStore.load_databases_for(2)
    assert_equal 'db/user/2_ideas', IdeaStore.filename
    assert_equal 'db/user/2_revisions', RevisionStore.filename
  end

  def test_the_idea_store_only_displays_ideas_for_the_current_user
    UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    UserStore.create({
      'id'           => 3,
      'username'     => 'bill',
      'password'     => 'god',
      'email'        => 'bill@example.com',
      'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
      'created_at'   => Time.now
      })
    UserStore.load_databases_for(2)
    IdeaStore.create({
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    IdeaStore.create({
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'created_at' => "2013-10-17 10:29:00 -0600"
      })
    UserStore.load_databases_for(3)
    IdeaStore.create({
      'title' => "Recreation",
      'description' => "Shooting guns",
      'tags' => 'nra',
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    UserStore.load_databases_for(2)
    assert 2, IdeaStore.portfolio_size
    UserStore.load_databases_for(3)
    assert 1, IdeaStore.portfolio_size
  end

  def test_the_idea_store_can_show_only_ideas_from_a_certain_portfolio
    UserStore.create({
          'id'           => 2,
          'username'     => 'ben',
          'password'     => 'secret',
          'email'        => 'bennlewis@gmail.com',
          'portfolios'    => { 1 => 'work', 2 => 'home', 3 => 'school' },
          'created_at'   => Time.now
          })
    UserStore.load_databases_for(2)
    IdeaStore.create({
      'title' => "Transporation",
      'description' => "Bicycles and busses",
      'tags' => 'bike, bus',
      'portfolio_id' => 1,
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    IdeaStore.create({
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'portfolio_id' => 1,
      'created_at' => "2013-10-17 10:29:00 -0600"
      })
    idea_3 = IdeaStore.create({
      'title' => "Recreation",
      'description' => "Shooting guns",
      'tags' => 'nra',
      'portfolio_id' => 2,
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    IdeaStore.current_portfolio = 1
    assert_equal 2, IdeaStore.all.length
    refute IdeaStore.find(idea_3.id)
    assert_equal 0, IdeaStore.search_for('nra').length
    IdeaStore.current_portfolio = 2
    assert_equal 1, IdeaStore.search_for('nra').length
  end

  def test_the_user_store_can_load_a_users_portfolios
    UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'school', 3 => 'secrets' },
      'created_at'   => Time.now
      })
    UserStore.load_portfolio_for(2, 'secrets')
    assert_equal 3, IdeaStore.current_portfolio
    assert_equal 0, IdeaStore.portfolio_size
    IdeaStore.create({
      'title' => "Recreation",
      'description' => "Shooting guns",
      'tags' => 'nra',
      'portfolio_id' => 3,
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    assert_equal 1, IdeaStore.portfolio_size
    UserStore.load_portfolio_for(2, 'work')
    assert_equal 0, IdeaStore.portfolio_size
  end

  def test_the_idea_store_can_change_an_ideas_portfolio
    UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'school', 3 => 'secrets' },
      'created_at'   => Time.now
      })
    UserStore.load_portfolio_for(2, 'secrets')
    idea = IdeaStore.create({
      'title' => "Recreation",
      'description' => "Shooting guns",
      'tags' => 'nra',
      'portfolio_id' => 3,
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    IdeaStore.change_portfolio_for_idea(1, 2)
    assert_equal 0, IdeaStore.portfolio_size
    UserStore.load_portfolio_for(2, 'school')
    assert_equal 1, IdeaStore.portfolio_size
  end

  def test_the_idea_store_can_delete_a_portfolio_and_its_ideas
    UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'school', 3 => 'secrets' },
      'created_at'   => Time.now
      })
    UserStore.load_portfolio_for(2, 'secrets')
    IdeaStore.create({
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'portfolio_id' => 3,
      'created_at' => "2013-10-17 10:29:00 -0600"
      })
    idea = IdeaStore.create({
      'title' => "Recreation",
      'description' => "Shooting guns",
      'tags' => 'nra',
      'portfolio_id' => 3,
      'created_at' => "2013-10-17 10:24:27 -0600"
      })
    assert_equal 2, IdeaStore.portfolio_size
    IdeaStore.delete_portfolio(3)
    assert_equal 0, IdeaStore.portfolio_size
  end

  def test_the_user_store_can_delete_a_portfolio
    UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'school', 3 => 'secrets' },
      'created_at'   => Time.now
      })
    UserStore.load_portfolio_for(2, 'secrets')
    UserStore.delete_portfolio(2, 3)
    assert_equal 1, IdeaStore.current_portfolio
  end

  def test_the_user_store_can_change_the_name_of_a_portfolio
    user = UserStore.create({
      'id'           => 2,
      'username'     => 'ben',
      'password'     => 'secret',
      'email'        => 'bennlewis@gmail.com',
      'portfolios'    => { 1 => 'work', 2 => 'school', 3 => 'secrets' },
      'created_at'   => Time.now
      })
    UserStore.load_portfolio_for(2, 'secrets')
    IdeaStore.create({
      'title' => "Sundays",
      'description' => "In the park with George",
      'tags' => 'gerschwin',
      'portfolio_id' => 3,
      'created_at' => "2013-10-17 10:29:00 -0600"
      })
    assert_equal 3, IdeaStore.current_portfolio
    assert_equal 1, IdeaStore.portfolio_size
    UserStore.rename_portfolio(2, 3, 'musicals')
    assert_equal 3, IdeaStore.current_portfolio
    assert_equal 1, IdeaStore.portfolio_size
  end


end