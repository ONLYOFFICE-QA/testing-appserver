# frozen_string_literal: true

require_relative '../top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer Placeholder for modules that are in progress of developing
  # https://user-images.githubusercontent.com/40513035/141085330-09584b43-6a2c-419c-9414-0c01219ea5a7.png
  class ModulePlaceHolder
    include TopToolbar
    include PageObject

    def initialize(instance, selected_module)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load(selected_module)
    end

    def wait_to_load(selected_module)
      @instance.webdriver.wait_until { selected_module_picture_present?(selected_module) }
    end

    def selected_module_picture_present?(selected_module)
      module_xpath = "//img[contains(@src,'#{selected_module}')]"
      @instance.webdriver.element_present?(module_xpath)
    end
  end
end
