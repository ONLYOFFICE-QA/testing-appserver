# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/documents_modules'

module TestingAppServer
  # AppServer Recent Documents
  # https://user-images.githubusercontent.com/40513035/149157614-12738cec-99b1-4045-a638-b282a6053adb.png
  class DocumentsRecent
    include DocumentsModules
    include TopToolbar
    include PageObject

    element(:header_recent, xpath: "//h1[@title='Recent']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_recent_element.present? }
    end
  end
end
