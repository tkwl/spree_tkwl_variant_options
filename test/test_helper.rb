# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

require 'ffaker'
require "shoulda"
require "sqlite3"
require 'factory_girl_rails'

begin; require "debugger"; rescue LoadError; end
begin; require "turn"; rescue LoadError; end

Spree::Zone.class_eval do
  def self.global
    find_by(name: 'GlobalZone') || FactoryGirl.create(:global_zone)
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'capybara/rails'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
options = {
  js_errors: false,
  timeout: 240,
  phantomjs_logger: StringIO.new,
  logger: nil,
  phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.default_wait_time = 10
Capybara.default_host = 'localhost:3000'


class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Spree::UrlHelpers

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = true

  teardown do
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end

class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end