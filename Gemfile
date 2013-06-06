source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.rc1'
gem 'bootstrap-sass', '2.3.0.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
gem "pg", :group => :production

# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'guard-rspec', '2.5.0'
  gem 'guard-zeus'
  gem "pg"
end

group :test do
  gem 'sqlite3', '1.3.7'
  gem 'selenium-webdriver', '2.0'
  gem 'capybara', '2.1.0.rc1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'cucumber-rails', '1.3.0', :require => false
  gem 'database_cleaner', '~> 1.0.0.RC1'
end

group :assets do
  gem 'sass-rails', '~> 4.0.0.rc1'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
end

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.0.1'
gem 'zeus'
