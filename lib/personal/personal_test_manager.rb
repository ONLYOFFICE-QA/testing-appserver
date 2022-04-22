# frozen_string_literal: true

require_relative '../testing_appserver/test_manager/test_manager_helper'

module TestingAppServer
  # it is helper for adding result to test case management system, like palladium and testrail
  # for using, create TestManager object in your mail describe
  # Example: test_manager = TestManager.new(suite_name: description)
  # Then, add result in `after: each` block
  # Example: test_manager.add_result(example)
  class PersonalTestManager
    include TestManagerHelper
    # @return [Object] testrail params
    attr_reader :testrail

    def initialize(params = {})
      params[:suite_name] ||= File.basename(__FILE__)
      params[:plan_name] ||= test_plan_name
      params[:plan_name_testrail] ||= params[:plan_name]
      params[:product_name] ||= 'Personal Autotests'
      @tcm_helper = OnlyofficeTcmHelper::TcmHelper.new(params)
      @palladium = init_palladium(params)

      init_testrail(params)
    end

    def portal_version_and_build_date
      test = TestingAppServer::PersonalTestInstance.new
      documents_page = TestingAppServer::PersonalSite.new(test).personal_login(test.user.mail, test.user.pwd)
      version, build_date = documents_page.portal_version_and_build_date
      portal = test.user.portal
      test.webdriver.quit
      [version, build_date, portal]
    end

    def portal_appserver_and_documents_version
      main_page, test = TestingAppServer::AppServerHelper.new.init_instance
      appserver_version, docs_version = main_page.portal_appserver_and_docs_version
      test.webdriver.quit
      portal = test.user.portal
      [appserver_version, docs_version, portal]
    end

    def test_plan_name
      # TODO: add version and build date using api after bug fix: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54664
      if ENV.fetch('SPEC_REGION', 'unknown').include?('com')
        appserver_version, docs_version, portal = portal_appserver_and_documents_version
        "#{portal} Appserver Version: #{appserver_version}, Docs Version: #{docs_version}"
      else
        version, build_date, portal = portal_version_and_build_date
        "#{portal} Version: #{version}, Build date: #{build_date}"
      end
    end
  end
end
