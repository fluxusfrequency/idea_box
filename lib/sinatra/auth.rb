require 'sinatra/base'
require 'sinatra/flash'
require 'digest/md5'
require './lib/idea_box'

module Sinatra
  module Auth
    module Helpers

      def authorized?
        session[:persona]
      end

      def protected!
        halt 401, slim(:unauthorized) unless authorized?
      end
    end

    def self.registered(app)
      app.helpers Helpers

      app.enable :sessions

      # app.set :username => 'ben',
      #         :password => 'password'

      app.get '/session/login' do
        slim :login
      end

      app.post '/session/login' do
        user = UserStore.find_by_username(params[:username].downcase)
        login_try = Digest::MD5.hexdigest(params[:password])
        if user && user.password == login_try
          session[:persona] = params[:username]
          flash[:notice] = "You are now logged in as #{session[:persona]}."
          redirect to("/"), locals: {user: user}
        else
          flash[:error] = "The username or password you entered was incorrect."
          redirect to('/session/login')
        end
      end

      app.get '/session/logout' do
        session[:persona] = nil
        flash[:notice] = "You have now logged out."
        redirect to ('/')
      end

      app.get '/session/create' do
        slim :create_user
      end

      app.post '/session/create' do 
        if params[:password] != params[:password_confirmation]
          flash[:error] = "Your password did not match your password confirmation. Please try again."
          redirect '/session/create'
        elsif
          UserStore.find_by_username(params[:username].downcase)
          flash[:error] = "Sorry, that username has already been taken. Please try again."
          redirect '/session/create'
        else
          UserStore.create({'username' => params[:username].downcase, 'password' => Digest::MD5::hexdigest(params[:password]), 'email' => params[:email]})
          flash[:notice] = "Your account was successfully created."
          redirect '/session/login'
        end
      end

    end

  end
  register Auth
end
