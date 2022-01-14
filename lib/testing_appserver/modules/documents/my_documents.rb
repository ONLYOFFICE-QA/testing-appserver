# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/documents_modules'

require_relative 'documents_common'
require_relative 'documents_favorites'
require_relative 'documents_private_room'
require_relative 'documents_recent'
require_relative 'documents_shared_with_me'
require_relative 'documents_trash'

module TestingAppServer
  # AppServer My Documents
  # https://user-images.githubusercontent.com/40513035/141085330-09584b43-6a2c-419c-9414-0c01219ea5a7.png
  class MyDocuments
    include DocumentsModules
    include TopToolbar
    include PageObject

    div(:header_my_documents, xpath: "//div[@title='My documents']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_my_documents_element.present? }
    end

    def files_present?(files)
      files.each do |file|
        return false unless file_present?(file)
      end
      true
    end
  end
end
