require 'slim'
require 'sinatra/base'
require 'sinatra/reloader'
require 'better_errors'
require 'sass'
require './lib/idea_box'


class IdeaBoxApp < Sinatra::Base

  set :method_override, true
  set :root, 'lib/app'

  register Sinatra::AssetPack

  assets {
    serve '/javscripts', from: 'javascripts'
    js :foundation, [
      'javascripts/foundation/foundation.js',
      'javascripts/foundation/foundation.*.js'
    ]

    js :application, [
      '/javascripts/vendor/*.js',
      '/javascripts/app.js'
    ]

    serve '/stylesheets', from: 'stylesheets'
    css :application, [
      '/stylesheets/normalize.css',
      '/stylesheets/app.css'
    ]

    js_compression :jsmin
    css_compression :sass
  }

  configure :development do
    register Sinatra::Reloader
    use BetterErrors::Middleware
    BetterErrors.application_root = 'lib/app'
  end

  not_found do
    slim :error
  end

  get '/' do
    slim :index, locals: { ideas: IdeaStore.all.sort, idea: Idea.new}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  get '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    slim :show, locals: { idea: idea }
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    slim :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/all/tags/:tag' do |tag|
    slim :tag_view, locals: { tag: tag }
  end

  get '/all/tags' do
    ideas = IdeaStore.sort_all_by_tags
    slim :all_tags, locals: { ideas: ideas }
  end

  get '/all/day' do
    ideas = IdeaStore.group_all_by_day_created
    slim :all_day, locals: { ideas: ideas }
  end

  get '/foundation/home' do
    slim :foundation_test
  end

  post '/search/result' do
    # search_result = IdeaStore.find_by_
    slim :search, locals: { search: params[:search_text], time_range: nil, result: false }
  end

  post '/search/time/result' do
    time_range = params[:time_range].split("-")
    slim :search, locals: { search: nil , time_range: time_range, result: nil }
  end

end