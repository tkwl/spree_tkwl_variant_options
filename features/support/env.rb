ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path("../../../test/dummy", __FILE__)

require "cucumber/rails"
require "factory_girl"
  
ActionController::Base.allow_rescue = false
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

Capybara.default_selector = :css

Cucumber::Rails::World.use_transactional_fixtures = false
DatabaseCleaner.strategy  = :truncation
  
Dir["#{File.expand_path("../../../", __FILE__)}/test/support/**/*.rb"].each { |f| require f }

World(HelperMethods)
World(FactoryGirl::Syntax::Methods)
# ensures spree preferencs are reset before each test
Before do
  Spree::Config.instance_variable_set("@configuration", nil)
  Spree::Role.where(name: 'admin').first_or_create!
  Spree::Role.where(name: 'user').first_or_create!
  @admin = Spree::LegacyUser.new do |u|
    u.email = "admin@example.com"
    u.password = "secret"
    u.password_confirmation = "secret"
  end
  @admin.save!
  @admin.spree_roles << Spree::Role.where(name: 'admin').first_or_create!
end

After do |scenario|
  # Do something after each scenario.
  # The +scenario+ argument is optional, but
  # if you use it, you can inspect status with
  # the #failed?, #passed? and #exception methods.
  if scenario.failed?
    if ENV['LOCAL']
      save_and_open_page
      page.save_screenshot("tmp/capybara/screenshots/#{scenario.exception.message}.png", full: true)   
    end
    if ENV['FAIL_FAST']
      Cucumber.wants_to_quit = true
    end
  end

end
