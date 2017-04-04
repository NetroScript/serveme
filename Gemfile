source 'https://rubygems.org'

gem 'rails', "~> 5.0.0"
gem 'sprockets'
gem 'haml'
gem 'puma'
gem 'omniauth-openid'
gem 'hashie'
gem 'omniauth-steam'
gem 'devise'
gem 'steam-condenser', :git => 'https://github.com/koraktor/steam-condenser-ruby'
gem 'base32_pure'
gem 'remote_lock',     :git => "https://github.com/Arie/remote_lock"
gem 'rack-attack'

gem 'lograge'

#Map uploads
gem 'carrierwave'
gem 'rbzip2', :git => 'https://github.com/koraktor/rbzip2'
gem 'rubyzip', require: 'zip'

#Logdaemon
gem 'tf2_line_parser'
gem 'eventmachine'
gem 'dante'

gem 'net-ssh'
gem 'net-sftp'
gem 'drape'
gem 'will_paginate'
gem 'zeroclipboard-rails'
gem "google_visualr", git: "https://github.com/Arie/google_visualr.git"
gem 'rack-cache'
gem 'paypal-sdk-rest'
gem 'stripe'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'geoip'
gem 'geocoder'
gem 'rbtrace'

gem 'dalli'
gem 'connection_pool'

#NFO server restarts
gem 'mechanize'
#Simrai server restarts
gem 'faraday'
gem 'american_date'
gem 'jbuilder'

gem 'ffi'
gem 'pg'
gem 'therubyracer'
gem 'oily_png'


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :deployment do
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'capistrano'
  gem 'capistrano-maintenance'
  gem 'capistrano-sidekiq'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-faster-assets'
  gem 'capistrano3-puma'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'rspec-activemodel-mocks'
  gem 'pry-nav'
  gem 'zonebie'
end

group :test_tools do
  gem 'coveralls', require: false
  gem 'fuubar'
end

group :production do
  gem "sentry-raven"
end

group :test do
  #Load minitest explicitly to work around shoulda issue
  gem "minitest"
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
  gem 'delorean'
  gem 'json_expressions'
  gem 'rails-controller-testing'

  #cucumber
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'capybara'
end

gem 'uglifier'
gem 'jquery-rails'
gem 'compass-rails'
gem 'sass'
gem 'sass-rails'
gem 'sassc'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'will_paginate-bootstrap'
gem 'execjs'
gem 'font-awesome-rails'
gem 'coffee-rails'
