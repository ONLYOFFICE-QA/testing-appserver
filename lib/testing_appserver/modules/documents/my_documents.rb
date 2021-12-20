# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/document_creation_field'
require_relative 'modules/documents_filter'
require_relative 'modules/documents_helper'
require_relative 'modules/documents_side_bar'

module TestingAppServer
  # AppServer Documents module
  # https://user-images.githubusercontent.com/40513035/141085330-09584b43-6a2c-419c-9414-0c01219ea5a7.png
  class MyDocuments
    include DocumentsCreationField
    include DocumentsFilter
    include DocumentsHelper
    include DocumentsSideBar
    include TopToolbar
    include PageObject

    span(:my_documents, xpath: "//span[@title = 'My documents']") # add_id

    image(:empty_folder, xpath: "//img[@alt='Empty folder image']") # add_id

    elements(:item_title, xpath: "//div[contains(@class, 'table-container_cell')]/a")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { my_documents_element.present? || empty_folder_element.present? }
    end

    def file_present?(file_name)
      item_title_elements.each do |current_element|
        return true if @instance.webdriver.get_attribute(current_element, 'title') == file_name
      end
      false
    end

    def files_present?(files)
      files.each do |file|
        return false unless file_present?(file)
      end
      true
    end
  end
end
