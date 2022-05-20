# frozen_string_literal: true

module TestingAppServer
  # AppServer field in list of documents for creating and editing documents, spreadsheets, presentations and folders
  # https://user-images.githubusercontent.com/40513035/143570421-1286f0db-80ff-4f24-9dc5-a7520d01326f.png
  module DocumentsCreationField
    include PageObject

    text_field(:file_name_field, xpath: "//input[contains(@class, 'edit-text')]")
    button(:save_file, xpath: "(//button[contains(@class, 'edit-button')])[1]") # add_id

    def file_currently_editing?
      file_name_field_element.present?
    end

    def add_name_to_file(name)
      file_name_field_element.send_keys(name)
      save_file_element.click
    end
  end
end
