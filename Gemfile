source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "redis", ">= 5.3.0"

# Use JavaScript with ESM import maps. [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator. [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework. [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# For building JSON APIs with ease.
gem "jbuilder"

# OpenStruct official gem, as the standard library version is deprecated.
gem "ostruct"

# HTTP client library abstraction layer
gem "faraday", ">= 2.12.0"

# CSS
gem "tailwindcss-rails", "~> 4.2"

group :test do
  # RSpec testing suite
  gem "rspec-rails", ">= 7.0.1"

  # Library for stubbing setting expectations on HTTP requests
  gem "webmock"

  # Code coverage analyzer
  gem "simplecov", require: false
end

group :development, :test do
  # Static analysis for security vulnerabilities
  gem "brakeman", require: false

  # Shim for loading .env files
  gem "dotenv"

  # Database for development and test environments
  gem "sqlite3", ">= 2.1.1", require: false

  # Debugging tool
  gem "pry", "~> 0.14.2"

  # Omakase Ruby styling
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end
