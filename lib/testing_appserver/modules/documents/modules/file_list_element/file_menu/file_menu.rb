# frozen_string_literal: true

require_relative 'delete_file_window'

module TestingAppServer
  # AppServer Documents file menu
  # https://user-images.githubusercontent.com/40513035/144551173-cfb59fe3-ac09-46ba-a1a7-352708e841ec.png
  module FileMenu
    include PageObject
    span(:delete_file, xpath: "//span[contains(text(), 'Delete')]") # add_id

    def delete_file
      delete_file_element.click
      DeleteFileWindow.new(@instance).confirm_files_deleting
    end
  end
end
