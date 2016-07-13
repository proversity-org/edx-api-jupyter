source 'https://rubygems.org'


gem 'rails', '4.2.6'
gem 'rails-api'
gem 'spring', :group => :development

group :production do
  gem 'mysql2'
end

gem 'rails_api_auth', :git => 'https://github.com/simplabs/rails_api_auth.git'
gem 'rack-cors', :require => 'rack/cors'
gem 'rack'
gem 'puma'

group :development do
  gem 'sqlite3'
  gem 'appraisal'
  gem 'rubocop'
  gem 'guard-rubocop'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
end
