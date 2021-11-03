# frozen_string_literal: true

require_relative 'appserver_main_page'

module TestingAppServer
  # AppServer Sign In page
  # https://user-images.githubusercontent.com/40513035/139641048-1b64d227-082f-4f2d-b751-87e4bf9cc1dd.png
  class AppServerSignIn
    include PageObject

    text_field(:sign_in_login, xpath: "//input[@id='login']")
    element(:sign_in_login_error, xpath: "//input[@id='login']/../p[contains(@class, 'error')]")
    text_field(:sign_in_password, xpath: "//input[@id='password']")
    element(:sign_in_password_error, xpath: "//input[@id='password']/../../../p[contains(@class, 'error')]")
    button(:sign_in_submit, xpath: "//button[@id='submit']")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { sign_in_login_element.present? }
    end

    def input_credentials(email, pwd)
      self.sign_in_login = email
      self.sign_in_password = pwd
    end

    def login_error?
      sign_in_login_error_element.present? || sign_in_password_error_element.present?
    end

    def sign_in(email, pwd)
      input_credentials(email, pwd)
      sign_in_submit_element.click
      return if login_error?

      @instance.webdriver.wait_until(100) { !sign_in_login_element.present? }
      AppServerMainPage.new(@instance)
    end
  end
end
