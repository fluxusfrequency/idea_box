require 'digest/md5'

class User
  attr_reader :id, :created_at
  attr_accessor :username, :password, :email, :portfolios

  def initialize(attributes={})
    # attributes = default_user.merge(attributes)
    @id          = attributes["id"]
    @username    = attributes["username"]
    @password    = Digest::MD5.hexdigest(attributes["password"])
    @email       = attributes["email"]
    @portfolios  = attributes["portfolios"]
    @created_at  = attributes["created_at"] || Time.now.to_s
  end

end