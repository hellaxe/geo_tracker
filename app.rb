require 'sinatra/base'
require 'mongoid'
require 'slim'

class GeoTrackerApp < Sinatra::Base
    configure :development do |config|
        require "sinatra/reloader"
        require 'pry'
        register Sinatra::Reloader
        Mongoid.load!("./config/database.yml", :development)
    end

    configure :test do |config|
        require 'pry'
        Mongoid.load!("./config/database.yml", :test)
    end

end

require_relative 'models/init'
require_relative 'controllers/init'
require_relative 'services/init'

