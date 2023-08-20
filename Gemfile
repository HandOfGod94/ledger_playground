# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bootsnap', require: false
gem 'double_entry', '~> 2.0.0.beta5'
gem 'money', '~> 6.16'
gem 'money-rails', '~> 1.15'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.7'
gem 'sqlite3', '~> 1.4'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'spring'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
end
