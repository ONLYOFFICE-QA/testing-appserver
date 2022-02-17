# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/documents_modules'

module TestingAppServer
  # AppServer Private Room Documents
  # https://user-images.githubusercontent.com/40513035/149347631-268baecf-5001-41da-8c8b-7370666b7ad5.png
  class DocumentsPrivateRoom
    include DocumentsModules
    include TopToolbar
    include PageObject

    element(:header_private_room, xpath: "//h1[@title='Private Room']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_private_room_element.present? }
    end
  end
end
