# frozen_string_literal: true

require_relative 'pop_up_windows/documents_copy'
require_relative 'pop_up_windows/documents_download_as'
require_relative 'pop_up_windows/documents_move_to'
require_relative 'pop_up_windows/documents_move_to_trash_window'
require_relative 'pop_up_windows/documents_sharing_settings'
require_relative 'pop_up_windows/documents_version_history'
require_relative 'document_creation_field'

module TestingAppServer
  # AppServer Documents List Item settings
  # https://user-images.githubusercontent.com/40513035/169487451-0255509f-d5cf-4040-a628-6682d0fc7ec1.png
  module DocumentsListItemSettings
    include PageObject
    include DocumentsCopy
    include DocumentsDownloadAs
    include DocumentsMoveTo
    include DocumentsMoveToTrashWindow
    include DocumentsSharingSettings
    include DocumentsVersionHistory
    include DocumentsCreationField

    span(:setting_edit, xpath: "//span[text() = 'Edit']")
    span(:setting_preview, xpath: "//span[text() = 'Preview']")
    span(:setting_sharing_settings, xpath: "//span[text() = 'Sharing settings']")

    span(:setting_view_details, xpath: "//span[text() = 'View Details']")
    div(:file_info, xpath: "//div[@id='InfoPanelWrapper']")
    element(:file_info_title, xpath: "//div[@id='InfoPanelWrapper']//p[contains(@class, ' text')]")

    span(:setting_version_history, xpath: "//span[text() = 'Version history']")
    span(:setting_finalize_version, xpath: "//span[text() = 'Finalize version']")
    span(:setting_show_version_history, xpath: "//span[text() = 'Show version history']")

    span(:setting_unblock, xpath: "//span[text() = 'Unblock/Check-in']")
    span(:setting_favorite, xpath: "//span[text() = 'Mark as favorite']") # add_id
    span(:setting_download, xpath: "//span[text() = 'Download']")
    span(:setting_download_as, xpath: "//span[text() = 'Download as']") # add_id

    span(:setting_move_or_copy, xpath: "//span[text() = 'Move or copy']")
    span(:setting_move_to, xpath: "//span[text() = 'Move to']")
    span(:setting_copy, xpath: "//span[text() = 'Copy']")
    span(:setting_create_a_copy, xpath: "//span[text() = 'Create a copy']")

    span(:setting_rename, xpath: "//span[text() = 'Rename']")
    span(:setting_delete, xpath: "//span[text() = 'Delete']") # add_id

    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")

    def open_file_settings(file_name)
      settings_xpath = "//a[contains(@title, '#{file_name}')]/../..//div[contains(@class, 'expandButton')]"
      @instance.webdriver.driver.find_element(:xpath, settings_xpath).click
      @instance.webdriver.wait_until { setting_delete_element.present? }
    end

    def file_settings(file_name, action, options = {})
      open_file_settings(file_name)
      case action
      when :edit
        edit_file_title
      when :preview
        preview_file_title
      when :sharing_settings
        setting_sharing_settings_element.click
      when :finalize_version
        finalize_version
      when :version_history
        version_history
      when :view_details
        view_details
      when :favorite
        mark_file_as_favorite
      when :download
        setting_download_element.click
      when :download_as
        download_file_as(options[:format])
      when :move_to
        move_to_file(options[:move_to_folder])
      when :copy
        copy_file(options[:copy_folder])
      when :create_copy
        create_a_copy_file
      when :rename
        rename_file(options[:rename_file])
      when :delete
        delete_file
      end
    end

    # @return [String] File title for which info box is currently opened
    def view_details
      setting_view_details_element.click
      @instance.webdriver.wait_until { file_info_element.present? }
      file_info_title_element.text
    end

    def move_or_copy_menu
      setting_move_or_copy_element.click
      @instance.webdriver.wait_until { setting_move_to_element.present? }
    end

    def create_a_copy_file
      move_or_copy_menu
      setting_create_a_copy_element.click
      @instance.webdriver.wait_until { success_toast_element.present? }
      @instance.webdriver.wait_until { !success_toast_element.present? }
    end

    def copy_file(folder)
      move_or_copy_menu
      setting_copy_element.click
      copy_to_folder(folder)
    end

    def move_to_file(folder)
      move_or_copy_menu
      setting_move_to_element.click
      move_to_folder(folder)
    end

    def delete_file
      setting_delete_element.click
      accept_deletion
    end

    def rename_file(rename_title)
      setting_rename_element.click
      @instance.webdriver.wait_until { file_currently_editing? }
      add_name_to_file(rename_title)
    end

    def settings_version
      setting_version_history_element.click
      @instance.webdriver.wait_until { setting_finalize_version_element.present? }
    end

    def version_history
      settings_version
      setting_show_version_history_element.click
      @instance.webdriver.wait_until { version_is_present?(1) }
      @instance.webdriver.wait_until { !setting_show_version_history_element.present? }
    end

    def finalize_version
      settings_version
      setting_finalize_version_element.click
      @instance.webdriver.wait_until { !setting_version_history_element.present? }
      OnlyofficeLoggerHelper.sleep_and_log('Waiting or version to change', 2)
    end

    def edit_file_title
      setting_edit_element.click
      check_opened_file_name
    end

    def preview_file_title
      setting_preview_element.click
      check_opened_file_name
    end

    def download_file_as(format)
      setting_download_as_element.click
      @instance.webdriver.wait_until { chose_format_element.present? }
      choose_format_to_convert(format)
    end

    def mark_file_as_favorite
      setting_favorite_element.click
      @instance.webdriver.wait_until_element_visible(success_toast_element)
      success_toast_element.click # close notification toast to avoid hovering over other elements
    end
  end
end
