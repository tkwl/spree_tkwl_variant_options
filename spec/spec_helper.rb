if ENV["COVERAGE"]
  require_relative 'rcov_exclude_list.rb'
  exlist = Dir.glob(@exclude_list)
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start do
    exlist.each do |p|
      add_filter p
    end
  end
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'
require 'pry'
require 'capybara/rspec'
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

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'

require 'spree_variant_options/factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::AuthorizationHelpers::Controller
  config.include Capybara::DSL

  config.mock_with :rspec
  config.color = true
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.after(:each, type: :feature) do |example| 
    missing_translations = page.body.scan(/translation missing: #{I18n.locale}\.(.*?)[\s<\"&]/)
    if missing_translations.any?
      #binding.pry
      puts "Found missing translations: #{missing_translations.inspect}"
      puts "In spec: #{example.location}"
    end
    if ENV['LOCAL']  && example.exception
      page.save_screenshot("tmp/capybara/screenshots/#{example.metadata[:description]}.png", full: true)
      save_and_open_page
    end
  end

  config.fail_fast = ENV['FAIL_FAST'] || false
end

if ENV["COVERAGE"]
  # Load all files except the ones in exclude list
  require_all(Dir.glob('**/*.rb') - exlist)
end