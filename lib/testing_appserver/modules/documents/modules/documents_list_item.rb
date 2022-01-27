# frozen_string_literal: true

module TestingAppServer
  # AppServer field in list of documents for creating and editing documents, spreadsheets, presentations and folders
  # https://user-images.githubusercontent.com/40513035/143570421-1286f0db-80ff-4f24-9dc5-a7520d01326f.png
  module DocumentsListItem
    include PageObject

    elements(:item_title, xpath: "//div[contains(@class, 'table-container_cell')]/a")

    image(:empty_folder, xpath: "//img[@alt='Empty folder image']") # add_id

    def file_present?(file_name)
      item_title_elements.each do |current_element|
        return true if @instance.webdriver.get_attribute(current_element, 'title').include?(file_name)
      end
      false
    end

    def files_present?(files)
      files.each do |file|
        return false unless file_present?(file)
      end
      true
    end
  end
end
