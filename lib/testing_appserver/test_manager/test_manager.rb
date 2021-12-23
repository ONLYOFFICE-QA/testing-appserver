# frozen_string_literal: true

require_relative '../data/private_data'
require 'palladium'
require 'onlyoffice_tcm_helper'
require 'onlyoffice_testrail_wrapper'
require_relative 'palladium_wrapper'
require_relative 'test_manager_testrail'

include OnlyofficeTestrailWrapper
include OnlyofficeTcmHelper
include Palladium

module TestingAppServer
  # it is helper for adding result to test case management system, like palladium and testrail
  # for using, create TestManager object in your mail describe
  # Example: test_manager = TestManager.new(suite_name: description)
  # Then, add result in `after: each` block
  # Example: test_manager.add_result(example)
  class TestManager
    include PalladiumWrapper
    include TestManagerTestrail
    # @return [Object] testrail params
    attr_reader :testrail

    def initialize(params = {})
      params[:suite_name] ||= File.basename(__FILE__)
      params[:plan_name] ||= test_plan_name
      params[:plan_name_testrail] ||= test_plan_name
      params[:product_name] ||= 'AppServer Autotests'
      @tcm_helper = OnlyofficeTcmHelper::TcmHelper.new(params)
      @palladium = init_palladium(params)

      init_testrail(params)
    end

    # @param example [RSpec::Core::Example] returned object in "after" block
    # @param instance[TestingAppServer::AppserverTestInstance] current instance
    # @param comment [String] data for result
    def add_result(example, instance, comment = '')
      result = @tcm_helper.parse(example)
      comment = "#{comment}Error #{instance.webdriver.webdriver_screenshot}\n" if test_failed_and_has_no_screenshot?(result,
                                                                                                                     example)
      formatting_describer(comment)
      @testrail&.add_result_to_test_case(example, comment)

      return unless @palladium

      add_palladium_result(result)
    end

    def test_failed_and_has_no_screenshot?(result, example)
      !result.comment.include?('Error screenshot') if example.exception
    end

    # take describer in TcmHelper.result_message and reformat it
    def formatting_describer(comment)
      result_message = JSON.parse(@tcm_helper.result_message)
      describer = result_message['describer'][0]['value']
      new_describer = []
      new_describer << { title: 'Custom comment', value: comment } unless comment == ''
      new_describer << { title: 'Comment', value: describer.split('Page address')[0] }
      new_describer << { value: describer.split('Page address: ')[1],
                         title: 'Page address' }
      new_describer << { value: (describer.split('Error screenshot: ')[1]).to_s,
                         title: 'Error screenshot',
                         type: :image }
      result_message['describer'] = new_describer
      @tcm_helper.result_message = result_message.to_json
    end

    # get code for colorize message in console
    def get_result_color(status_name)
      { failed: 45, pending: 43, passed: 42, passed_2: 46, aborted: 41, blocked: 44 }[status_name]
    end

    def test_plan_name
      # TODO: add version and build date using api after bug fix: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54664
      "Test run date: #{Time.now.strftime('%d/%m/%Y')}, Portal: #{TestingAppServer::UserData::DEFAULT_PORTAL}"
    end

    private

    # Add result info to palladium
    # @param result [TcmHelper] info to add
    # @return [nil]
    def add_palladium_result(result)
      @palladium.set_result(status: result.status.to_s, description: result.result_message, name: result.case_name)
      OnlyofficeLoggerHelper.log("Set test case result to palladium: #{result.status}." \
                                 "URL: #{@palladium.result_set_link}",
                                 get_result_color(result.status))
    rescue StandardError => e
      OnlyofficeLoggerHelper.log("Can't write result to palladium. Error: #{e}")
    end
  end
end
