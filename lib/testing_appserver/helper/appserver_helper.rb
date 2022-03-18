# frozen_string_literal: true

require_relative '../appserver_test_instance'
require_relative '../sign_in_page'

module TestingAppServer
  # Helper methods for AppServer initializing
  class AppServerHelper
    attr_accessor :test, :user

    def init_instance(user = UserData.new)
      test = AppserverTestInstance.new(user)
      test.webdriver.webdriver_error('HTTP Error 503. Service Unavailable') if test.webdriver.get_page_source.include?('Error 503')
      login_page = SignInPage.new(test)
      @main_page = login_page.sign_in(user.mail, user.pwd)
      [@main_page, test]
    end
  end
end
