# frozen_string_literal: true

require_relative 'pop_up_windows/documents_copy'
require_relative 'pop_up_windows/documents_sharing_settings'
require_relative 'pop_up_windows/documents_move_to_trash'
require_relative 'pop_up_windows/documents_move_to'

module TestingAppServer
  # AppServer Documents group actions
  # https://user-images.githubusercontent.com/40513035/154399060-d4e64342-f0cc-49d5-9d0a-673fd588fd02.png
  module DocumentsGroupActions
    include PageObject
    include DocumentsCopy
    include DocumentsMoveTo
    include DocumentsMoveToTrash
    include DocumentsSharingSettings

    header_xpath = "//div[contains(@class, 'table-container_group-menu')]"
    button(:group_menu_share_file, xpath: "#{header_xpath}//button[text() = 'Share']") # add_id
    button(:group_menu_download_file, xpath: "#{header_xpath}//button[text() = 'Download']") # add_id
    button(:group_menu_download_as_file, xpath: "#{header_xpath}//button[text() = 'Download as']") # add_id
    button(:group_menu_move_to, xpath: "#{header_xpath}//button[text() = 'Move to']") # add_id
    button(:group_menu_copy_file, xpath: "#{header_xpath}//button[text() = 'Copy']") # add_id
    button(:group_menu_delete_file, xpath: "#{header_xpath}//button[text() = 'Delete']") # add_id
    button(:group_menu_remove_from_list, xpath: "#{header_xpath}//button[text() = 'Remove from list']") # add_id

    div(:file_loading_bar, xpath: "//div[contains(@class, 'layout-progress-bar')]")

    def group_menu_download_file
      group_menu_download_file_element.click
      @instance.webdriver.wait_until { !file_loading_bar_element.present? }
    end

    def group_menu_move_to(folder)
      group_menu_move_to_element.click
      move_to_folder(folder)
    end

    def group_menu_copy_to(folder)
      group_menu_copy_file_element.click
      copy_to_folder(folder)
    end

    def group_menu_share_file
      group_menu_share_file_element.click
      @instance.webdriver.wait_until { plus_share_element.present? }
    end

    def group_menu_delete
      group_menu_delete_file_element.click
      accept_deletion
    end

    def all_group_actions_present?
      group_menu_share_file_element.present? && group_menu_move_to_element.present? &&
        group_menu_delete_file_element.present? && download_copy_download_as_present?
    end

    def download_copy_download_as_present?
      group_menu_download_file_element.present? && group_menu_copy_file_element.present? &&
        group_menu_download_as_file_element.present?
    end

    def all_group_actions_for_favorites_present?
      group_menu_share_file_element.present? && group_menu_delete_file_element.present? &&
        download_copy_download_as_present?
    end

    def all_group_actions_for_folder_present?
      group_menu_share_file_element.present? && group_menu_move_to_element.present? &&
        group_menu_delete_file_element.present? && group_menu_download_file_element.present? &&
        group_menu_copy_file_element.present?
    end

    def all_group_actions_for_resent_present?
      group_menu_share_file_element.present? && download_copy_download_as_present?
    end

    def all_group_actions_for_shared_with_me_present?
      group_menu_remove_from_list_element.present? && download_copy_download_as_present?
    end
  end
end
