source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'pg'
gem 'pygments.rb', '~> 0.2.7' #highlight syntax:
gem 'bcrypt-ruby', '3.0.1' #password_digest
gem 'stringex', '~> 1.3.2' #string exstenions
gem 'email_validator'
#gem 'bootstrap-sass', '2.0.0' #twitter css
gem 'faker', '1.0.1' #creating sample users
gem 'will_paginate', '3.0.3'
#gem 'bootstrap-will_paginate', '0.0.5'
gem "gitolite", :git => "https://github.com/gitlabhq/gitolite-client.git" #ruby interface to gitolite


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'rmagick' #requires on ubuntu: apt-get install libmagick9-dev


group :development do
  gem 'annotate', '~> 2.4.1.beta' #annotate models with schema info
  gem 'rspec-rails', '2.9.0 ' #rspec generators
  gem 'guard-rspec', '0.5.5' #automate tests
end

group :test do
  gem 'factory_girl_rails', '1.4.0' #factory for models
  gem 'capybara', '1.1.2'   #english like testing
  gem 'rspec-rails', '2.9.0'   #rspec generators
  #notify for guarded rspecs (linux):
  gem 'rb-inotify', '0.8.8', :platform => :ruby
  gem 'libnotify', '0.5.9', :platform => :ruby
  #notify for guarded rspecs (win):
  gem 'rb-fchange', '0.0.5', :platform => :mingw
  gem 'rb-notifu', '0.0.4', :platform => :mingw
  gem 'win32console', '1.3.0', :platform => :mingw
  gem 'guard-spork', '0.3.2'  #speed test up
  gem 'spork', '0.9.0'  #speed test up
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
