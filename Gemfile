source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'jquery-rails'
gem 'execjs'
gem 'therubyracer', :platform => :ruby
gem 'pg'
gem 'pygments.rb', '~> 0.2.7' #highlight syntax:
gem 'bcrypt-ruby', '3.0.1' #password_digest
gem 'stringex', '~> 1.3.2' #string exstenions
gem 'email_validator'
gem 'faker', '1.0.1' #creating sample users
gem 'will_paginate', '3.0.3'
gem 'gitolite', :git => 'https://github.com/gitlabhq/gitolite-client.git' #ruby interface to gitolite
gem 'rmagick' #requires on unix: apt-get install libmagick9-dev
gem 'net-sftp'
gem 'spawn', :git => 'git://github.com/rfc2822/spawn'
#gem 'ptools' #check if file is binary

group :assets do
	gem 'sass-rails',   '~> 3.2.3'
	gem 'coffee-rails', '~> 3.2.1'
	gem 'uglifier', '>= 1.0.3'
end

group :development do
	gem 'annotate', '~> 2.4.1.beta' #annotate models with schema info
	gem 'rspec-rails', '2.9.0 ' #rspec generators
	gem 'guard-rspec', '0.5.5' #automate tests
end

group :test do
	gem 'factory_girl_rails', '1.4.0' #factory for models
	gem 'capybara', '1.1.2'   #english like testing
	gem 'rspec-rails', '2.9.0'   #rspec generators
	gem 'rb-inotify', '0.8.8', :platform => :ruby
	gem 'libnotify', '0.5.9', :platform => :ruby
	gem 'rb-fchange', '0.0.5', :platform => :mingw
	gem 'rb-notifu', '0.0.4', :platform => :mingw
	gem 'win32console', '1.3.0', :platform => :mingw
	gem 'guard-spork', '0.3.2'  #speed test up
	gem 'spork', '0.9.0'  #speed test up
end
