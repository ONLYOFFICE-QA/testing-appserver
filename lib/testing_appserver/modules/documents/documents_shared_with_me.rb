# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/documents_modules'

module TestingAppServer
  # AppServer Shared with me Documents
  # https://user-images.githubusercontent.com/40513035/149161300-5155a2ba-d22b-4e80-8a75-ac9c171a4b23.png
  class DocumentsSharedWithMe
    include DocumentsModules
    include TopToolbar
    include PageObject

    div(:header_shared_with_me, xpath: "//div[@title='Shared with me']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_shared_with_me_element.present? }
    end
  end
end
