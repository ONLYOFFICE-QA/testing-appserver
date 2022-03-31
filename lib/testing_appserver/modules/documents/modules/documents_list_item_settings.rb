# frozen_string_literal: true

require_relative 'pop_up_windows/documents_copy'
require_relative 'pop_up_windows/documents_download_as'
require_relative 'pop_up_windows/documents_move_to'
require_relative 'pop_up_windows/documents_move_to_trash'
require_relative 'pop_up_windows/documents_sharing_settings'

module TestingAppServer
  # AppServer Documents List Item settings
  # https://user-images.githubusercontent.com/40513035/152883639-181ee5f8-093b-409b-bdcb-de3b611559c9.png
  module DocumentsListItemSettings
    include PageObject
    include DocumentsCopy
    include DocumentsDownloadAs
    include DocumentsMoveTo
    include DocumentsMoveToTrash
    include DocumentsSharingSettings

    span(:setting_favorite, xpath: "//span[text() = 'Mark as favorite']") # add_id
    span(:setting_download_as, xpath: "//span[text() = 'Download as']") # add_id
    span(:setting_delete, xpath: "//span[text() = 'Delete']") # add_id

    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")
    element(:star_picture, xpath: "//*[contains(@class, 'favorite icons-group badge')]")

    def open_file_settings(file_name)
      settings_xpath = "//a[contains(@title, '#{file_name}')]/../..//div[contains(@class, 'expandButton')]"
      @instance.webdriver.driver.find_element(:xpath, settings_xpath).click
      @instance.webdriver.wait_until { setting_delete_element.present? }
    end

    def file_settings(file_name, action, options = {})
      open_file_settings(file_name)
      case action
      when :favorite
        mark_file_as_favorite
      when :download_as
        setting_download_as_element.click
        @instance.webdriver.wait_until { chose_format_element.present? }
        choose_file_for_form_template(options[:format])
      end
    end

    def mark_file_as_favorite
      setting_favorite_element.click
      @instance.webdriver.wait_until { success_toast_element.present? }
      success_toast_element.click # close notification toast to avoid hovering over other elements
      @instance.webdriver.wait_until { star_picture_element.present? }
    end
  end
end
