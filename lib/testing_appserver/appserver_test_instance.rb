# frozen_string_literal: true

require 'bundler/setup'
require 'onlyoffice_api'
require 'onlyoffice_documentserver_testing_framework'
require 'onlyoffice_file_helper'
require 'onlyoffice_testrail_wrapper'
require 'onlyoffice_webdriver_wrapper'
require 'onlyoffice_tcm_helper'
require 'palladium'
require_relative 'data/helper_files/helper_files'
require_relative 'data/user_data'
require_relative 'helper/api/api_helper'
require_relative 'helper/appserver_helper'
require_relative 'test_manager/test_manager'

include OnlyofficeDocumentserverTestingFramework
include OnlyofficeTestrailWrapper
include OnlyofficeWebdriverWrapper

module TestingAppServer
  # Instance of browser to perform actions
  class AppserverTestInstance
    attr_accessor :webdriver, :doc_instance, :user

    def initialize(user, browser = :chrome)
      @user = user
      @webdriver = WebDriver.new(browser, record_video: false)
      @webdriver.open(UserData::DEFAULT_PORTAL)
    end

    def init_online_documents
      @doc_instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new(webdriver: @webdriver)
      raise 'Cannot init online documents, because browser was not initialized' if @webdriver.driver.nil?

      @doc_instance.selenium = @webdriver
    end
  end
end
