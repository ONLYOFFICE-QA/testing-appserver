# frozen_string_literal: true

require 'bundler/setup'
require 'active_support'
require 'httparty'
require 'onlyoffice_testrail_wrapper'
require 'onlyoffice_webdriver_wrapper'
require 'onlyoffice_tcm_helper'
require 'palladium'
require_relative 'data/user_data/user_data'
require_relative 'appserver_helper'

include OnlyofficeTestrailWrapper
include OnlyofficeWebdriverWrapper

module TestingAppServer
  # Instance of browser to perform actions
  class AppserverTestInstance
    attr_accessor :webdriver
    alias driver webdriver
    alias selenium webdriver

    def initialize(browser = :chrome)
      @webdriver = WebDriver.new(browser, record_video: false)
      @webdriver.open('http://appserver.qa-onlyoffice.net/')
    end

    # @return [Hash] private data of site
    def private_data
      @private_data ||= AppServerPrivateData.new.decrypt
    end
  end
end
