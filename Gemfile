source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem "slim-rails"
gem "devise"
gem 'pg'
gem 'jquery-rails'
gem 'cocoon'
gem 'validate_url'
gem 'poppler'
gem 'popper'
gem 'hirb'
gem 'gon'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'rubygems-server'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10.13'
gem 'oj'
gem 'reek'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'mysql2', '~> 0.4',    :platform => :ruby
gem 'thinking-sphinx', '~> 5.5'
gem 'rexml'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem "rspec-rails", "~> 6.0.0"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "rails-controller-testing"
  gem 'letter_opener'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "rubocop"
  gem 'pry'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma', "6.0.0.beta1"

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "selenium-webdriver"
  gem "launchy"
  gem 'simplecov', require: false
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
