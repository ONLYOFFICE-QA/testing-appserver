# frozen_string_literal: true

require 'bundler/setup'
require 'onlyoffice_api'
require 'onlyoffice_testrail_wrapper'
require 'onlyoffice_webdriver_wrapper'
require 'onlyoffice_tcm_helper'
require 'palladium'
require_relative 'data/user_data'
require_relative 'helper/api/api_helper'
require_relative 'helper/appserver_helper'

include OnlyofficeTestrailWrapper
include OnlyofficeWebdriverWrapper

module TestingAppServer
  # Instance of browser to perform actions
  class AppserverTestInstance
    attr_accessor :webdriver

    def initialize(browser = :chrome)
      @webdriver = WebDriver.new(browser, record_video: false)
      @webdriver.open(UserData::DEFAULT_PORTAL)
    end
  end
end
