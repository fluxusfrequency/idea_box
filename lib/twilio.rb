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

      def fetch_messages
        twilio_client.account.sms.messages.list
      end

      def make_ideas_from_raw_texts(texts)
        text_ideas = []
        texts.each_with_index do |sms, i|
          parts = sms.body.scan(/\S+/)
          text_ideas << Idea.new({"id" => i, "title" => parts[0], "description" => parts[1..parts.length].join(" "), "tags" => "text", "portfolio_id" => 6})
        end
        text_ideas
      end

      def set_idea_store_portfolio_to_texts
        IdeaStore.filename = "db/user/#{user.id}_ideas"
        IdeaStore.current_portfolio = 6
      end

    end

    def self.registered(app)
      app.helpers Helpers

      app.get '/sms' do
        text_user = UserStore.all.find{|user| params[:From].to_s.match(user.phone)}
        IdeaStore.filename = "db/user/#{text_user.id}_ideas"
        parts = params[:Body].scan(/\S+/)
        IdeaStore.create({"title" => parts[0], "description" => parts[1..parts.length].join(" "), "tags" => "text", "portfolio_id" => 6})
      end

      app.get '/texts' do
        protected!
        IdeaStore.current_portfolio = 6
        slim :feed, locals: { ideas: IdeaStore.all, user: user, show_resources: false, sort: 'rank'}
      end

      # app.get '/texts' do
      #   protected!
      #   my_messages = fetch_messages.select {|message| message.from == user.phone }
      #   ideas = make_ideas_from_raw_texts(my_messages)
      #   set_idea_store_portfolio_to_texts
      #   slim :feed, locals: { ideas: Idea., user: user, show_resources: false, sort: 'rank'}
      # end

      # app.get '/all_texts' do
      #   messages = twilio_client.account.sms.messages.list
      #   slim :texts, locals: { messages: messages }
      # end

    end
  end
  register Sms
end
