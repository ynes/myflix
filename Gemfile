source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem "bootstrap_form"
gem "bcrypt"
gem "fabrication"
gem "faker"
gem "sidekiq"

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'rspec-rails', '2.99'
  gem "debugger"
  gem "capybara"
end

group :test do
  gem 'database_cleaner', git: 'git@github.com:bmabey/database_cleaner.git'
  gem "shoulda-matchers"
  gem "launchy"
  gem 'capybara-email'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

