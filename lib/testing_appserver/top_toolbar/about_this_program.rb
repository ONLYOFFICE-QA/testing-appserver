# frozen_string_literal: true

module TestingAppServer
  # AppServer About this program
  # https://user-images.githubusercontent.com/40513035/156100165-fd0eca33-42f7-4e08-9eb6-01650eb61a44.png
  class AboutThisProgram
    include PageObject

    element(:appserver_version, xpath: "(//a[contains(text(), 'App Server')]/../p)[2]") # add_id
    element(:docs_version, xpath: "(//a[contains(text(), 'Docs')]/../p)[2]") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { appserver_version_element.present? }
    end

    def appserver_and_docs_version
      appserver_version = appserver_version_element.text[2..-1]
      docs_version = docs_version_element.text[2..-1]
      [appserver_version, docs_version]
    end
  end
end
