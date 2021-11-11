# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer Documents module
  # https://user-images.githubusercontent.com/40513035/141085330-09584b43-6a2c-419c-9414-0c01219ea5a7.png
  class DocumentsModule
    include TopToolbar
    include PageObject

    span(:my_documents, xpath: "//span[@title = 'My documents']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { my_documents_element.present? }
    end
  end
end
