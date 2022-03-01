# frozen_string_literal: true

require_relative '../testing_appserver/modules/documents/my_documents'

module TestingAppServer
  # Personal Sign In page
  # https://user-images.githubusercontent.com/40513035/155835899-ac53c927-983a-4574-a6e4-96b529341b42.png
  class PersonalSignIn
    include PageObject

    text_field(:personal_email, xpath: "//input[@type='email']")
    text_field(:personal_pwd, xpath: "//input[@type='password']")
    button(:personal_sign_in_submit, xpath: "//button[@type='submit']")

    div(:error_toast, xpath: "//div[contains(@class, 'Toastify__toast--error')]")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { personal_pwd_element.present? }
    end

    def input_credentials(email, pwd)
      self.personal_email = email
      self.personal_pwd = pwd
    end

    def sign_in(email, pwd)
      input_credentials(email, pwd)
      personal_sign_in_submit_element.click
      return if error_toast_element.present?

      @instance.webdriver.wait_until { !personal_sign_in_submit_element.present? }
      MyDocuments.new(@instance)
    end
  end
end
