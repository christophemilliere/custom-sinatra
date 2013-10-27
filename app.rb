$:.unshift File.expand_path('../../../lib', __FILE__)
require 'sinatra'
require 'sinatra/base'
require "sinatra/reloader" if development?
require "compass"
require 'haml'
require 'sinatra/assetpack'
require 'sinatra/base'
require 'sinatra/support'

set :views, 'views'
set :haml, {:format => :html5} # default Haml format is :xhtml

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  register Sinatra::CompassSupport

  Compass.configuration do |config|
    config.project_path     = root
    config.images_dir       = "public/images"
    config.http_generated_images_path = "/images"
    config.sass_dir = 'public/stylesheets'
  end

  set :sass, Compass.sass_engine_options
  set :sass, { :load_paths => sass[:load_paths] + [ "#{self.root}/assets/stylesheets" ] }

  register Sinatra::AssetPack

  assets do

    serve '/css', :from =>'public/stylesheets'
    serve 'js', :from => 'public/javascripts'
    serve 'images', :from => 'public/images'


    js :main, [
      'js/jquery.js'
    ]
    css :main, [
      '/css/screen.css'
    ]

    # js_compression :jsmin
    css_compression :sass
  end

  get '/' do
    haml :index
  end

  post '/message' do
    @send = params[:send]
    haml :message
  end

  get '/contact' do
    haml :contact
  end
end

if __FILE__ == $0
  App.run!
end


