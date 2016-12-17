require 'rack/test'
require 'rspec'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() GeoTrackerApp end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean