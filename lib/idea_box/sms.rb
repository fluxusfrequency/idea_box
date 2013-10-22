class SMS
  attr_reader :id, :from, :body, :created_at

  def initialize(attributes={})
    attributes = default_sms.merge(attributes)
    @id          = attributes["id"]
    @from        = attributes["from"]
    @body        = attributes["body"]
    @created_at  = attributes["created_at"]
  end

  def to_h
    { "id"         => id,
      "from"       => from,
      "body"       => body,
      "created_at" => created_at
    }
  end

  def default_sms
    { "id"         => next_id,
      "from"       => "0000000000",
      "body"       => "Empty",
      "created_at" => Time.now.to_s
    }
  end

  def next_id
    begin
      SMSStore.size + 1
    rescue
      1
    end
  end

end