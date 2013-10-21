class Portfolio
  attr_reader :id, :created_at
  attr_accessor :username, :password, :email, :portfolios

  def initialize(attributes={})
    attributes = default_user.merge(attributes)
    @id          = attributes["id"]
    @username    = attributes["username"]
    @password    = attributes["password"]
    @email       = attributes["email"]
    @portfolios  = attributes["portfolios"]
    @created_at  = attributes["created_at"]
  end

  def to_h
    { "id" => id,
      "username" => username,
      "password" => password,
      "email" => email,
      "portfolios" => portfolios,
      "created_at" => created_at,
    }
  end

  def default_user
    { "id"         => next_id,
      "username"   => "new user",
      "password"   => Digest::MD5.hexdigest("password"),
      "email"      => "johndoe@example.com",
      "portfolios" => { 1 => 'work'},
      "created_at" => Time.now.to_s
    }
  end

  def next_id
    begin
      UserStore.size + 1
    rescue
      1
    end
  end

end