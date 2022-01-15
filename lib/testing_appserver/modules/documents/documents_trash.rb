# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/documents_modules'

module TestingAppServer
  # AppServer Documents Trash
  # https://user-images.githubusercontent.com/40513035/149161588-37caa025-fae6-44c6-a80d-2d9550e2d66b.png
  class DocumentsTrash
    include DocumentsModules
    include TopToolbar
    include PageObject

    div(:header_trash, xpath: "//div[@title='Trash']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_trash_element.present? }
    end
  end
end