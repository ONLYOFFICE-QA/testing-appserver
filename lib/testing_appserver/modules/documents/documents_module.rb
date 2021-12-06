# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/document_creation_field'
require_relative 'modules/documents_helper'
require_relative 'modules/documents_side_bar'
require_relative 'modules/file_list_element/file_list_element'

module TestingAppServer
  # AppServer Documents module
  # https://user-images.githubusercontent.com/40513035/141085330-09584b43-6a2c-419c-9414-0c01219ea5a7.png
  class DocumentsModule
    include DocumentsCreationField
    include DocumentsHelper
    include DocumentsSideBar
    include FileListElement
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
