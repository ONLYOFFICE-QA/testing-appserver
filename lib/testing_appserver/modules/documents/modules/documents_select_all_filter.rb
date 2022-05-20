# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents select all filter
  # https://user-images.githubusercontent.com/40513035/169463896-2be2c558-a153-49d4-b3d6-7fbc07db020b.png
  module DocumentsSelectAllFilter
    include PageObject

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

    def select_files_filter(type)
      open_select_all_filter
      instance_eval("select_#{type}_element.click", __FILE__, __LINE__) # choose filter for Select All checkbox
      @instance.webdriver.wait_until { !select_documents_element.present? }
    end

    def open_select_all_filter
      select_all_filter_element.click
      @instance.webdriver.wait_until { select_documents_element.present? }
    end

    def all_select_all_filters_present?
      open_select_all_filter
      select_folders_element.present? && select_all_documents_filters_present? &&
        select_all_media_and_archives_filters_present?
    end

    def select_all_filters_for_recent_present?
      open_select_all_filter
      select_all_documents_filters_present?
    end

    def select_all_filters_for_favorites_present?
      open_select_all_filter
      select_all_documents_filters_present? && select_all_media_and_archives_filters_present?
    end

    def select_all_documents_filters_present?
      select_all_element.present? && select_all_files_element.present? && select_spreadsheets_element.present? &&
        select_documents_element.present? && select_presentations_element.present?
    end

    def select_all_media_and_archives_filters_present?
      select_images_element.present? && select_archives_element.present? && select_media_element.present?
    end
  end
end
