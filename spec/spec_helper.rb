require 'rack/test'
require 'rspec'
require 'database_cleaner'
require 'factory_girl'
require 'pry'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() GeoTrackerApp end
end

# For RSpec 2.x and 3.x
RSpec.configure do |c| 
    c.include FactoryGirl::Syntax::Methods
    c.include RSpecMixin
    c.before(:suite) do
        FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
        FactoryGirl.find_definitions
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.clean
        Task.create_indexes
    end

    c.around(:each) do |example|
        DatabaseCleaner.cleaning do
            example.run
        end
    end
end




