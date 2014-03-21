source "https://rubygems.org"

ruby "2.0.0"
#ruby-gemset=vetrounds

gem "rails", "~> 4.0.3"

gem "bootstrap-sass", "~> 3.1.1.0"
gem "font-awesome-rails", "~> 4.0.3.1"
gem "bcrypt-ruby", "~> 3.1.5"
gem "event_tracker", "~> 0.2.1"
gem "sentry-raven", "~> 0.7.1"
gem 'google-analytics-rails'

group :production do
  gem "pg", "~> 0.17.1"
  gem "rails_12factor", "~> 0.0.2"
end

group :development, :test do
  gem "sqlite3", "~> 1.3.9"
  gem "rspec-rails", "~> 2.14.1"
  gem "libnotify" if /linux/ =~ RUBY_PLATFORM
  gem "growl" if /darwin/ =~ RUBY_PLATFORM
  gem "factory_girl_rails"
end

group :test do
  gem "selenium-webdriver", "~> 2.40.0"
  gem "capybara", "~> 2.2.1"
  gem "launchy", "~> 2.4.2"
  gem "guard-rspec"
  gem "database_cleaner", "~> 1.2.0"
end

gem "sass-rails", "~> 4.0.1"
gem "uglifier", "~> 2.4.0"
gem "coffee-rails", "~> 4.0.1"
gem "jquery-rails", "~> 3.1.0"
gem "turbolinks", "~> 2.2.1"
gem "jbuilder", "~> 2.0.3"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", "~> 0.4.0", require: false
end