# frozen_string_literal: true

require_relative 'modules/documents_modules'

module TestingAppServer
  # AppServer Common Documents
  # https://user-images.githubusercontent.com/40513035/149121217-17e31452-3157-42c1-b69a-e1f820954cea.png
  class DocumentsCommon
    include DocumentsModules
    include PageObject

    element(:header_common, xpath: "//h1[@title='Common']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_common_element.present? }
    end
  end
end
