ENV['RACK_ENV'] = 'test'

require './lib/app'

require 'bundler'
Bundler.require

require 'rack/test'
require 'minitest/autorun' 
require 'minitest/pride'
require 'sinatra'
require 'sinatra/assetpack'