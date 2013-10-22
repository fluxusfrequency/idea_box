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

      def user
        @user ||= UserStore.find_by_username(session[:persona])
      end

    end

    def self.registered(app)
      app.helpers Helpers

      app.get '/sms' do
        text_user = UserStore.all.find{|user| user.phone == params[:From].to_s}
        if params[:From] && params[:Body]
          IdeaStore.filename = "db/user/#{text_user.id}_ideas"
          parts = params[:Body].scan(/\S+/)
          IdeaStore.create({"title" => parts.first, "description" => parts[1..parts.length].join(" "), "portfolio_id" => 6})
        end   
      end

      # app.get '/texts' do
      #   protected!
      #   raw_messages = twilio_client.account.sms.messages.list
      #   my_messages = raw_messages.select {|message| message.from == user.phone }
      #   slim :texts, locals: { messages: my_messages }
      # end

      # app.get '/all_texts' do
      #   messages = twilio_client.account.sms.messages.list
      #   slim :texts, locals: { messages: messages }
      # end

    end
  end
  register Sms
end
