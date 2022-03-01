# frozen_string_literal: true

require_relative 'modules/documents_modules'

module TestingAppServer
  # AppServer Favorite Documents
  # https://user-images.githubusercontent.com/40513035/149155311-e23551ed-fb57-4b95-92a4-d29e554d0444.png
  class DocumentsFavorites
    include DocumentsModules
    include PageObject

    element(:header_favorites, xpath: "//h1[@title='Favorites']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_favorites_element.present? }
    end
  end
end
