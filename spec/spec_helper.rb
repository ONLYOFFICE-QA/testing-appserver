# frozen_string_literal: true

require_relative '../lib/testing_appserver'
require_relative 'spec_helper/shared_examples'
require 'onlyoffice_testrail_wrapper'
require 'rspec'
require 'rspec/retry'

RSpec.configure do |config|
  is_debug = OnlyofficeFileHelper::RubyHelper.debug?
  config.default_retry_count = if is_debug
                                 1
                               else
                                 2
                               end
  config.verbose_retry = true
end
