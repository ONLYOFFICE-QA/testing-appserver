# frozen_string_literal: true

require_relative 'pop_up_windows/documents_copy'
require_relative 'pop_up_windows/documents_download_as'
require_relative 'pop_up_windows/documents_move_to'
require_relative 'pop_up_windows/documents_move_to_trash'
require_relative 'pop_up_windows/documents_sharing_settings'
require_relative 'pop_up_windows/document_empty_trash'
require_relative 'documents_list_item'

module TestingAppServer
  # AppServer Documents group actions
  # https://user-images.githubusercontent.com/40513035/169240519-65997808-66a9-4415-90f9-66f8d37ca100.png
  module DocumentsGroupActions
    include PageObject
    include DocumentsCopy
    include DocumentsDownloadAs
    include DocumentsMoveTo
    include DocumentsMoveToTrashWindow
    include DocumentsSharingSettings
    include DocumentsListItem
    include DocumentsEmptyTrashWindow

    header_xpath = "//div[contains(@class, 'table-container_group-menu')]"
    button(:group_menu_share_file, xpath: "#{header_xpath}//button[@title = 'Share']") # add_id
    button(:group_menu_download_file, xpath: "#{header_xpath}//button[@title='Download']") # add_id
    button(:group_menu_download_as_file, xpath: "#{header_xpath}//button[@title = 'Download as']") # add_id
    button(:group_menu_move_to, xpath: "#{header_xpath}//button[@title = 'Move to']") # add_id
    button(:group_menu_copy_file, xpath: "#{header_xpath}//button[@title = 'Copy']") # add_id
    button(:group_menu_delete_file, xpath: "#{header_xpath}//button[@title = 'Delete']") # add_id
    button(:group_menu_remove_from_list, xpath: "#{header_xpath}//button[@title = 'Remove from favorites']") # add_id

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

    def group_menu_download_as(format)
      group_menu_download_as_file_element.click
      choose_format_to_convert(format)
    end

    def group_menu_share_file
      group_menu_share_file_element.click
      @instance.webdriver.wait_until { plus_share_element.present? }
    end

    def group_menu_delete
      group_menu_delete_file_element.click
      accept_deletion
    end

    def remove_all_files_and_clean_trash
      unless files_list.empty?
        files_list.each do |file|
          check_file_checkbox(file)
        end
        group_menu_delete
      end
      documents_navigation(:trash)
      empty_trash_header_button_clicked unless files_list.empty?
      documents_navigation(:my_documents)
    end

    def all_group_actions_present?
      group_menu_share_file_element.present? && group_menu_move_to_element.present? &&
        group_menu_delete_file_element.present? && download_copy_download_as_present?
    end

    def personal_group_actions_present?
      download_copy_download_as_present? && group_menu_move_to_element.present? &&
        group_menu_delete_file_element.present? && !group_menu_share_file_element.present?
    end

    def download_copy_download_as_present?
      group_menu_download_file_element.present? && group_menu_copy_file_element.present? &&
        group_menu_download_as_file_element.present?
    end

    def all_group_actions_for_favorites_present?
      group_menu_share_file_element.present? && group_menu_delete_file_element.present? &&
        download_copy_download_as_present? && !group_menu_move_to_element.present?
    end

    def personal_all_group_actions_for_favorites_present?
      group_menu_remove_from_list_element.present? && download_copy_download_as_present? &&
        !group_menu_move_to_element.present? && !group_menu_share_file_element.present?
    end

    def all_group_actions_for_folder_present?
      group_menu_share_file_element.present? && group_menu_move_to_element.present? &&
        group_menu_delete_file_element.present? && group_menu_download_file_element.present? &&
        group_menu_copy_file_element.present?
    end

    def all_group_actions_for_resent_present?
      group_menu_share_file_element.present? && download_copy_download_as_present? &&
        !group_menu_move_to_element.present? && !group_menu_delete_file_element.present?
    end

    def all_group_actions_for_shared_with_me_present?
      group_menu_remove_from_list_element.present? && download_copy_download_as_present?
    end
  end
end
