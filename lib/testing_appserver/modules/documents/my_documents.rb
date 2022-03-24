# frozen_string_literal: true

require_relative 'modules/documents_modules'

require_relative 'documents_common'
require_relative 'documents_favorites'
require_relative 'documents_private_room'
require_relative 'documents_recent'
require_relative 'documents_shared_with_me'
require_relative 'documents_trash'
require_relative 'settings/connected_clouds'

module TestingAppServer
  # AppServer My Documents
  # https://user-images.githubusercontent.com/40513035/141085330-09584b43-6a2c-419c-9414-0c01219ea5a7.png
  class MyDocuments
    include DocumentsModules
    include PageObject

    element(:header_my_documents, xpath: "//h1[@title='My documents']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_my_documents_element.present? }
    end
  end
end
