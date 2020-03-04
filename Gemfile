# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.0'

# TODO: Explicitly require some gems as false so that startup time is optimized in dev mode.
gem 'rails',                   '4.2.6'
gem 'bcrypt',                  '3.1.11'
gem 'faker',                   '1.4.2' # TODO: Shouldn't this only be required for non-prod (or more specifically only for test) envs?
gem 'carrierwave',             '1.3.2'
gem 'mini_magick',             '3.8.0'
gem 'fog',                     '1.36.0'
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-sass',          '3.4.1'
gem 'sass-rails',              '5.0.2'
gem 'uglifier',                '2.7.2'
gem 'coffee-rails',            '4.1.0'
gem 'jquery-rails',            '4.0.4'
gem 'turbolinks',              '2.3.0'
gem 'jbuilder',                '2.2.3'
gem 'jc-validates_timeliness', '3.1.1'
gem 'pg',                      '0.18.4'
gem 'sdoc',                    '0.4.0', group: :doc # TODO: Are we generating some kind of docs? If not, this is not required
gem 'net-ssh',                 '3.1.1'
gem 'feature_toggle',          '0.0.3'
gem 'ruby-saml',               '1.1.1'
gem 'webmock',                 '2.1.0' # TODO: Shouldn't this only be required for non-prod (or more specifically only for test) envs?
gem 'bootstrap_form',          '2.3.0'
gem 'json',                    '~> 1.7', '>= 1.7.7'
gem 'selectize-rails',         '0.12.1'
gem 'font-awesome-sass',       '4.6.2'

group :development, :test do
  gem 'annotate',                 '~> 2.7.0'
  # gem 'spring',                   '1.7.1'
  gem 'quiet_assets',             '~> 1.1.0'
  gem 'bundler-audit',            '0.5.0', require: false
  gem 'byebug',                   '3.4.0'
  gem 'web-console',              '2.1.3'
  gem 'rspec-rails',              '3.4.2'
  gem 'rspec-activemodel-mocks',  '1.0.3'
  gem 'rspec-mocks',              '3.4.1'
  gem 'guard-rspec',              '4.7.2', require: false
  gem 'guard-rails',              '~> 0.7.2', require: false
  gem 'fuubar',                   '2.0.0'
  gem 'factory_girl_rails',       '4.7.0'
  gem 'capybara',                 '~> 2.1'
  gem 'rack_session_access',      '0.1.1'
  gem 'jasmine-rails',            '0.10.7'
  gem 'poltergeist',              '1.10.0'
  gem 'database_cleaner',         '1.5.3'
  gem 'nested_form',              '0.3.2'
  gem 'selenium-webdriver',       '2.53.0'
  gem 'bullet',                   '~> 5.0.0'
  gem 'metric_fu',                '~> 4.12.0', require: false
end

group :development do
  gem 'brakeman', '~> 3.2.1', require: false
  gem 'flamegraph', '~> 0.1.0', require: false
  gem 'rack-mini-profiler', '~> 0.9.8'
  gem 'binding_of_caller', '~> 0.7.2'

  gem 'rubocop', '~> 0.41.1', require: false
  gem 'rubocop-rspec', '~> 1.5', require: false
  # gem 'pronto', '~> 0.3.3'

  gem 'guard-bundler', '~> 2.1.0', require: false
  # gem 'rb-fchange', '~> 0.0.6', require: false
  # gem 'rb-fsevent', '~> 0.9.5', require: false
  # gem 'rb-inotify', '~> 0.9.5', require: false
  # gem 'spring-commands-rspec'

  # Use Capistrano for deployment
  # gem 'capistrano-rvm', '~> 0.1.2', require: false
  # gem 'capistrano-bundler', '~> 1.1.4', require: false
  # gem 'capistrano-rails', '~> 1.1.6', require: false
  # gem 'capistrano-passenger', '~> 0.2.0', require: false
  # gem 'capistrano-faster-assets', '~> 1.0', require: false
  # gem 'capistrano-scm-gitcopy', git: 'https://github.com/xuwupeng2000/capsitrano-scm-gitcopy', tag: '0.0.10', require: false
  # gem 'airbrussh', '~> 0.8.0', require: false

  # The following are only needed from time-to-time
  # gem 'derailed_benchmarks', '~> 1.1.3', require: false
  # gem 'stackprof', '~> 0.2.7', require: false
  # gem 'rails_layout', '~> 1.0.26'
  # gem 'lol_dba', '~> 2.0.0'
  # gem 'active_sanity', '~> 0.3.0'
  # gem 'jshint', '~> 1.4.0'
end

group :test do
  gem 'simplecov', '0.12.0'
end

group :production, :staging do
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '3.12.4'
end
