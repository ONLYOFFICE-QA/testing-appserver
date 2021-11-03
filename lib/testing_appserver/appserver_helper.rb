# frozen_string_literal: true

require_relative 'appserver_test_instance'
require_relative 'appserver_sign_in_page'

module TestingAppServer
  # Helper methods for site initializing
  class AppServerHelper
    attr_accessor :test

    def init_instance(user = UserData.new)
      test = AppserverTestInstance.new
      if test.webdriver.get_page_source.include?('Error 503')
        test.webdriver.webdriver_error('HTTP Error 503. Service Unavailable')
      end
      login_page = AppServerSignIn.new(test)
      @main_page = login_page.sign_in(user.mail, user.pwd)
      [@main_page, test]
    end
  end
end
