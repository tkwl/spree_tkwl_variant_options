# # encoding: UTF-8
# require 'rubygems'
# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end

# #require 'rake'
# require 'rake/testtask'

# Bundler::GemHelper.install_tasks

# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib'
#   t.libs << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end

# require 'cucumber/rake/task'
# Cucumber::Rake::Task.new do |t|
#   t.cucumber_opts = %w{--format pretty}
# end

# task :default => [ :test, :cucumber ]

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'
require 'spree/testing_support/extension_rake'

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_variant_options'
  Rake::Task['extension:test_app'].invoke
end

Bundler::GemHelper.install_tasks
