source 'https://rubygems.org'

ruby '2.3.0'

# TODO: Use annotate gem
# TODO: Explicitly require some gems as false so that startup time is optimized in dev mode.
gem 'rails',                   '4.2.5.2'
gem 'bcrypt',                  '3.1.11'
gem 'faker',                   '1.4.2'    # TODO: Shouldn't this only be required for non-prod (or more specifically only for test) envs?
gem 'carrierwave',             '0.10.0'
gem 'mini_magick',             '3.8.0'
gem 'fog',                     '1.36.0'
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-sass',          '3.2.0.0'
gem 'sass-rails',              '5.0.2'
gem 'uglifier',                '2.7.2'
gem 'coffee-rails',            '4.1.0'
gem 'jquery-rails',            '4.0.4'
gem 'turbolinks',              '2.3.0'
gem 'jbuilder',                '2.2.3'
gem 'spring',                  '1.7.1'
gem 'jc-validates_timeliness', '3.1.1'
gem 'pg',                      '0.18.4'
gem 'sdoc',                    '0.4.0', group: :doc   # TODO: Are we generating some kind of docs? If not, this is not required
gem 'net-ssh',                 '3.1.1'
gem 'feature_toggle',          '0.0.3'
gem 'ruby-saml',               '1.1.1'
gem 'webmock',                 '2.1.0'    # TODO: Shouldn't this only be required for non-prod (or more specifically only for test) envs?
gem 'bootstrap_form',          '2.3.0'
gem 'json',                    '~> 1.7', '>= 1.7.7'
gem 'selectize-rails',         '0.12.1'
gem 'font-awesome-sass',       '4.6.2'

group :development, :test do
  gem 'bundler-audit',  '0.5.0'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.1.3'
  gem 'rspec-rails',  '3.4.2'
  gem 'rspec-activemodel-mocks',    '1.0.3'
  gem 'guard-rspec',  '4.7.2', require: false
  gem 'fuubar',     '2.0.0'
  gem 'factory_girl_rails', '4.7.0'
  gem 'capybara',   '~> 2.1'
  gem 'rack_session_access', '0.1.1'
  gem 'jasmine-rails', '0.10.7'
  gem 'poltergeist',  '1.10.0'
  gem 'database_cleaner',   '1.5.3'
  gem 'nested_form',    '0.3.2'
  gem 'selenium-webdriver',   '2.53.0'
end

group :test do
  gem 'simplecov',    '0.11.2'
end

group :production, :staging do
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '2.15.3'
end
