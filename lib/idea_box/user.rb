require 'digest/md5'

class User
  attr_reader :id, :created_at
  attr_accessor :username, :password, :email, :portfolios

  def initialize(attributes={})
    attributes = default_user.merge(attributes)
    @id          = attributes["id"]
    @username    = attributes["username"]
    @password    = attributes["password"]
    @email       = attributes["email"]
    @portfolios  = attributes["portfolios"]
    @phone       = attributes["phone"]
    @created_at  = attributes["created_at"]
  end

  def to_h
    { "id" => id,
      "username" => username,
      "password" => password,
      "email" => email,
      "portfolios" => portfolios,
      "phone"      => phone,
      "created_at" => created_at,
    }
  end

  def default_user
    { "id"         => next_id,
      "username"   => "new user",
      "password"   => Digest::MD5.hexdigest("password"),
      "email"      => "johndoe@example.com",
      "portfolios" => { 1 => 'work', 6 => 'texts'},
      "phone"      => "+10000000000",
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

  def phone
    phone = @phone.scan(/[0-9]/).join
    if phone.length == 11 && phone.start_with?("1")
      phone = phone[1..-1]
    elsif phone.length != 10
      phone = "0000000000"
    else
      return phone
    end
    phone
  end

  def load_databases
    load_ideas
    load_revisions
  end

  def load_ideas
    IdeaStore.filename = "db/user/#{id}_ideas"
  end

  def load_revisions
    RevisionStore.filename = "db/user/#{id}_revisions"
  end

end