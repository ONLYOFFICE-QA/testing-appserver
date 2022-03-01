# frozen_string_literal: true

require_relative 'personal_sign_in'

module TestingAppServer
  # Personal Site for login and sign up
  # https://user-images.githubusercontent.com/40513035/155840030-becca2a2-b32d-4308-a598-2730a2e0b42d.png
  class PersonalSite
    include PageObject

    button(:personal_login, xpath: "//button[contains(@class, 'header-button')]")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { personal_login_element.present? }
    end

    def personal_login(email, pwd)
      personal_login_element.click
      PersonalSignIn.new(@instance).sign_in(email, pwd)
    end
  end
end
