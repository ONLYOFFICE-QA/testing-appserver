# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents list files actions
  # https://user-images.githubusercontent.com/40513035/151462280-e1e09124-7d11-47b5-9061-76d584386d67.png
  module DocumentsListActions
    include PageObject

    label(:select_all_checkbox, xpath: "//label[contains(@class, 'table-container_header-checkbox')]")

    div(:select_all_filter, xpath: "(//div[contains(@class, 'combo-button')])[1]") # add_id
    div(:select_all, xpath: "//div[@label='All']") # add_id
    div(:select_folders, xpath: "//div[@label='Folders']") # add_id
    div(:select_images, xpath: "//div[@label='Images']") # add_id
    div(:select_archives, xpath: "//div[@label='Archives']") # add_id
    div(:select_documents, xpath: "//div[@label='Documents']") # add_id
    div(:select_media, xpath: "//div[@label='Media']") # add_id
    div(:select_presentations, xpath: "//div[@label='Presentations']") # add_id
    div(:select_spreadsheets, xpath: "//div[@label='Spreadsheets']") # add_id
    div(:select_all_files, xpath: "//div[@label='All files']") # add_id

    def select_all_files
      select_all_checkbox_element.click
      @instance.webdriver.wait_until { select_all_filter_element.present? }
    end

    def select_files_filter(type)
      select_all_files
      open_select_all_filter
      instance_eval("select_#{type}_element.click", __FILE__, __LINE__) # choose filter for Select All checkbox
      @instance.webdriver.wait_until { !select_documents_element.present? }
    end

    def open_select_all_filter
      select_all_filter_element.click
      @instance.webdriver.wait_until { select_documents_element.present? }
    end

    def all_select_all_filters_present?
      select_all_files
      open_select_all_filter
      select_all_element.present? && select_folders_element.present? && select_images_element.present? &&
        select_archives_element.present? && select_documents_element.present? && select_media_element.present? &&
        select_presentations_element.present? && select_spreadsheets_element.present? &&
        select_all_files_element.present?
    end

    def select_all_filters_for_recent_present?
      select_all_files
      open_select_all_filter
      select_all_element.present? && select_all_files_element.present? && select_spreadsheets_element.present? &&
        select_documents_element.present? && select_presentations_element.present?
    end
  end
end
