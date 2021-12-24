# frozen_string_literal: true

module TestingAppServer
  # AppServer Debug Info
  # https://user-images.githubusercontent.com/40513035/147329630-3b1d05c2-7236-4b1f-9845-58bc15e21db3.png
  class DebugInfo
    include PageObject

    paragraph(:version, xpath: "//p[contains(text(), 'Version')]") # add_id
    paragraph(:build_date, xpath: "//p[contains(text(), 'Build date')]") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { version_element.present? }
    end

    def version_and_build_date
      version = version_element.text.split[-1]
      build_date = build_date_element.text.split[-1]
      [version, build_date]
    end
  end
end
