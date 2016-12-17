require 'sinatra'
require 'mongoid'
require 'slim'
class GeoTrackerApp < Sinatra::Base
    configure :development do |config|
        Mongoid.load!("./config/database.yml", :development)
    end

end

require_relative 'models/init'
require_relative 'controllers/init'
require_relative 'services/init'

