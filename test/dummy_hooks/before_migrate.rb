rake "spree:install:migrations"

insert_into_file File.join('config', 'routes.rb'), :after => "Rails.application.routes.draw do\n" do
  "  # Mount Spree's routes\n  mount Spree::Core::Engine, :at => '/'\n"
end

# Copy spree user initializer
template "initializers/spree_user.rb", "config/initializers/spree_user.rb"

# remove all stylesheets except core
%w(backend frontend).each do |ns|
  template "spree/#{ns}/all.js",  "app/assets/javascripts/spree/#{ns}/all.js",  :force => true
  template "spree/#{ns}/all.css", "app/assets/stylesheets/spree/#{ns}/all.css", :force => true
end

# Fix sass load error by using the converted css file
template "spree/frontend/screen.css", "app/assets/stylesheets/spree/frontend/screen.css"

run "rails g spree_variant_options:install"
