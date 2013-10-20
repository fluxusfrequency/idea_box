require 'sinatra/base'
require 'sinatra/flash'

module Sinatra
  module Auth
    module Helpers

      def authorized?
        session[:admin]
      end

      def protected!
        halt 401,slim(:unauthorized) unless authorized?
      end
    end

    def self.registered(app)
      app.helpers Helpers

      app.enable :sessions

      app.set :username => 'ben',
              :password => 'password'

      app.get '/session/login' do
        slim :login
      end

      app.post '/session/login' do
        if params[:username] == settings.username && params[:password] == settings.password
          session[:admin] = true
          session[:persona] = params[:username]
          flash[:notice] = "You are now logged in as #{settings.username}."
          redirect to('/')
        else
          flash[:notice] = "The username or password you entered was incorrect."
          redirect to('/session/login')
        end
      end

      app.get '/session/logout' do
        session[:admin] = nil
        session[:persona] = nil
        flash[:notice] = "You have now logged out."
        redirect to ('/')
      end
    end

  end
  register Auth
end
