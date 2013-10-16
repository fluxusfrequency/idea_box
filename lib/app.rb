require 'slim'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative './idea_box/idea.rb'
require_relative './idea_box/idea_store.rb'


class IdeaBoxApp < Sinatra::Base

  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
    register Sinatra::AssetPack
  end

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

  not_found do
    slim :error
  end

  get '/' do
    @show_index += 3 if @show_index
    @show_index ||= 0 
    slim :index, locals: { ideas: IdeaStore.all.sort, idea: Idea.new, show_index: @show_index }
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
    slim :search, locals: { search: params[:search_text], result: false }
  end

  post '/all/times' do

  end

end