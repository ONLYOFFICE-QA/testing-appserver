# frozen_string_literal: true

require_relative '../lib/testing_appserver'
require 'onlyoffice_testrail_wrapper'
require 'rspec'
require 'rspec/retry'

def config
  @config ||= TestingHelpCentreOnlyoffice::Config.new
end

RSpec.configure do |config|
  is_debug = OnlyofficeFileHelper::RubyHelper.debug?
  config.default_retry_count = if is_debug
                                 1
                               else
                                 2
                               end
  config.verbose_retry = true
end
