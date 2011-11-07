require 'bundler/setup'
require 'fileutils'
require 'sinatra/base'
require 'rack/coffee'

# Set environment and run Bundler require
ENV['RACK_ENV'] = 'production' if ENV['RACK_ENV'].nil?
Bundler.require(:default, ENV['RACK_ENV']) if defined?(Bundler)


# Enable cookie based sessions
use Rack::Session::Cookie

# Enable coffee script for development
use(
  Rack::Coffee, 
  :root => settings.root, 
  :urls => '/coffee', 
  :class_urls => '/coffee/classes', 
  :output_path => '/public',
  :cache => true) if ENV['RACK_ENV'] == 'development'

require './sliding_file_viewer'

run Rack::Cascade.new [SlidingFileViewer.new]

