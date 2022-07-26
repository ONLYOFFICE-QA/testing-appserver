# frozen_string_literal: true

require_relative 'modules/documents_modules'
require_relative 'modules/pop_up_windows/document_empty_trash'

module TestingAppServer
  # AppServer Documents Trash
  # https://user-images.githubusercontent.com/40513035/149161588-37caa025-fae6-44c6-a80d-2d9550e2d66b.png
  class DocumentsTrash
    include DocumentsModules
    include PageObject
    include DocumentsMoveToTrashWindow
    include DocumentsEmptyTrashWindow

    element(:header_trash, xpath: "//h1[@title='Trash' or text()='Trash']") # add_id

    button(:group_menu_restore, xpath: "//div[contains(@class, 'table-container_group-menu')]//button[@title = 'Restore']")
    button(:restore_save, xpath: "//button[contains(@class, 'select-file-modal-dialog-buttons-save')]")

    span(:restore_to_my_documents, xpath: "//span[@class = 'rc-tree-title']")
    span(:empty_trash_text, xpath: "//div[contains(@class, 'empty-folder_container')]/span[text() = 'No docs here yet']")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { header_trash_element.present? }
    end

    def restore_from_trash
      group_menu_restore
      restore_to_my_documents_element.click
      restore_save
      @instance.webdriver.wait_until { success_delete_toast_element.present? }
      @instance.webdriver.wait_until { !success_delete_toast_element.present? }
    end

    def trash_empty?
      empty_trash_text?
    end
  end
end
