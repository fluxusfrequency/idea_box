require 'sinatra/base'
require 'sinatra/flash'
require './lib/idea_box'

module Sinatra
  module Sms
    module Helpers

      def twilio_account_sid
        "ACa1631d5e7fc967cfec655880d9c4b979"
      end

      def twilio_auth_token
        "58a4a6db32ce13134a1751bc4933a2d4"
      end

      def twilio_client 
        @twilio_client ||= Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
      end

      def twilio_number
        "(719) 375-2176"
      end
    end

    def self.registered(app)
      app.helpers Helpers

      app.get '/sms' do
        SMSStore.filename = "db/user/#{user.id}_ideas"
        messages = SMSStore.all || []
        slim :sms, locals: { messages: messages}
      end

      app.post '/sms/?' do
        SMSStore.filename = "db/user/#{user.id}_ideas"
        # twiml = Twilio::TwiML::Response.new do |r|
        #   r.Message "Recieved your idea!"
        # end
        if params[:from] && params[:body]
          from = params[:From]
          body = params[:Body]
          SMSStore.create({"from" => from, "body" => body})
        else
          from = 'Sender'
          body = 'Message'
        end
        slim :sms, locals: { from: from, body: body}
      end
    end
  end
  register Sms
end
