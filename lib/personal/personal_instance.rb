# frozen_string_literal: true

require 'bundler/setup'
require 'onlyoffice_api'
require 'onlyoffice_documentserver_testing_framework'
require 'onlyoffice_file_helper'
require 'onlyoffice_testrail_wrapper'
require 'onlyoffice_webdriver_wrapper'
require 'onlyoffice_tcm_helper'
require 'palladium'
require_relative 'personal_user_data'
require_relative 'personal_main_pager'
require_relative 'personal_test_manager'
require_relative '../testing_appserver/data/helper_files/helper_files'
require_relative '../testing_appserver/data/general_data'
require_relative '../testing_appserver/helper/api/api_helper'

include OnlyofficeDocumentserverTestingFramework
include OnlyofficeTestrailWrapper
include OnlyofficeWebdriverWrapper

module TestingAppServer
  # Instance of browser to perform actions
  class PersonalTestInstance
    attr_accessor :webdriver, :doc_instance, :user

    def initialize(user = PersonalUserData.new, browser = :chrome)
      @user = user
      @webdriver = WebDriver.new(browser, record_video: false)
      @webdriver.open(user.portal)
    end

    def init_online_documents
      @doc_instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new(webdriver: @webdriver)
      raise 'Cannot init online documents, because browser was not initialized' if @webdriver.driver.nil?

      @doc_instance.selenium = @webdriver
    end
  end
end
