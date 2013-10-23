class DatabaseConfigurator
  def self.configure(env)
    if url = ENV['DATABASE_URL']
      # postgres://user:pass@host/db
      uri = URI.parse(url)
      # username = uri.username
      # password = uri.password
      # ActiveRecord::Base.establish_connection(.. user uri accessors ..)
    else
      dbconfig = YAML::load(File.open(File.expand_path('database.yml', 'config')))
      ActiveRecord::Base.establish_connection(dbconfig[env])
    end
  end
end