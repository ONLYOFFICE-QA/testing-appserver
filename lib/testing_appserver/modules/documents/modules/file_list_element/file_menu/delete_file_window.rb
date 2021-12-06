# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents delete file window
  # https://user-images.githubusercontent.com/40513035/144552040-d992d777-1769-41c6-83f1-0890416d6043.png
  class DeleteFileWindow
    include PageObject

    button(:move_to_trash, xpath: "//button[contains(@class, 'button-dialog-accept')]") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { move_to_trash_element.present? }
    end

    def confirm_files_deleting
      move_to_trash_element.click
      @instance.webdriver.wait_until { !move_to_trash_element.present? }
      DocumentsModule.new(@instance)
    end
  end
end
