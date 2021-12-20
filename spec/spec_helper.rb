# frozen_string_literal: true

require_relative '../lib/testing_appserver'
require_relative '../shared_example/documents_filter/docx_xlsx_pptx_users_groups_filter'
require_relative '../shared_example/documents_filter/documents_folder_filter'
require_relative '../shared_example/documents_filter/documents_img_media_archives_filter'
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
