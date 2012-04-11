source 'https://rubygems.org'


gem 'rails', '3.2.2'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
#highlight syntax:
gem 'pygments.rb', '~> 0.2.7'



gem 'stringex', '~> 1.3.2'
gem 'email_validator'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end



group :development do
  #annotate models with schema info:
  gem 'annotate', '~> 2.4.1.beta'
  #rspec generators:
  gem 'rspec-rails', '2.9.0'
  #automate tests:
  gem 'guard-rspec', '0.5.5'
end

group :test do
  #english like testing:
  gem 'capybara', '1.1.2'
  #rspec generators:
  gem 'rspec-rails', '2.9.0'
  #notify for guarded rspecs (linux):
  gem 'rb-inotify', '0.8.8', :platform => :ruby
  gem 'libnotify', '0.5.9', :platform => :ruby
  #notify for guarded rspecs (win):
  gem 'rb-fchange', '0.0.5', :platform => :mingw
  gem 'rb-notifu', '0.0.4', :platform => :mingw
  gem 'win32console', '1.3.0', :platform => :mingw
  #speed test up:
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
end


gem 'jquery-rails'

gem 'execjs'
gem 'therubyracer', :platform => :ruby

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
