# frozen_string_literal: true

require_relative 'test_manager_helper'

module TestingAppServer
  # it is helper for adding result to test case management system, like palladium and testrail
  # for using, create TestManager object in your mail describe
  # Example: test_manager = TestManager.new(suite_name: description)
  # Then, add result in `after: each` block
  # Example: test_manager.add_result(example)
  class TestManager
    include TestManagerHelper
    # @return [Object] testrail params
    attr_reader :testrail

    def initialize(params = {})
      params[:suite_name] ||= File.basename(__FILE__)
      params[:plan_name] ||= test_plan_name
      params[:plan_name_testrail] ||= params[:plan_name]
      params[:product_name] ||= 'AppServer Autotests'
      @tcm_helper = OnlyofficeTcmHelper::TcmHelper.new(params)
      @palladium = init_palladium(params)

      init_testrail(params)
    end

    def version_and_build_date
      main_page, test = TestingAppServer::AppServerHelper.new.init_instance
      version, build_date = main_page.portal_version_and_build_date
      test.webdriver.quit
      [version, build_date]
    end

    def test_plan_name
      # TODO: add version and build date using api after bug fix: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54664
      version, build_date = version_and_build_date
      "Version: #{version}, Build date: #{build_date}, Portal: #{TestingAppServer::UserData::DEFAULT_PORTAL}"
    end
  end
end
