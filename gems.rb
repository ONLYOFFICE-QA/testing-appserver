# frozen_string_literal: true

source 'https://rubygems.org'
gem 'onlyoffice_tcm_helper'
gem 'onlyoffice_testrail_wrapper'
gem 'onlyoffice_webdriver_wrapper'
gem 'page-object'
gem 'palladium'
gem 'rake'
gem 'rspec'
gem 'rspec_passed_time_formatter'
gem 'rspec-retry'
gem 'wrata_api'

group :development do
  gem 'overcommit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end
