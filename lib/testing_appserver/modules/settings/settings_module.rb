# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer Settings module
  # https://user-images.githubusercontent.com/40513035/141249748-3507011d-87b2-45c0-8e04-50ff13e80c12.png
  class SettingsModule
    include TopToolbar
    include PageObject

    link(:common_customization, xpath: "//a[@href='/settings/common/customization']")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { common_customization_element.present? }
    end
  end
end
