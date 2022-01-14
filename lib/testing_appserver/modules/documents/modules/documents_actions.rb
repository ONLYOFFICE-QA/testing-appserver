# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents module side bar
  # https://user-images.githubusercontent.com/40513035/143567448-7678bdd2-8950-4551-98dd-490eff6cae8a.png
  module DocumentsActions
    include PageObject

    # actions
    div(:actions, xpath: "//p[contains(@class, 'main-button_text')]/../../div") # add_id
    span(:actions_new_document, xpath: "//span[text()='New Document']") # add_id
    span(:actions_new_spreadsheet, xpath: "//span[text()='New Spreadsheet']") # add_id
    span(:actions_new_presentation, xpath: "//span[text()='New Presentation']") # add_id
    span(:actions_form_template, xpath: "//span[text()='Form template']") # add_id
    span(:actions_new_folder, xpath: "//span[text()='New Folder']") # add_id
    span(:actions_upload_files, xpath: "//span[text()='Upload files']") # add_id
    span(:actions_upload_folders, xpath: "//span[text()='Upload folder']") # add_id
    text_field(:file_uploader, xpath: "//input[@id='customFileInput']")
    div(:progress_bar, xpath: "//div[contains(@class, 'layout-progress-bar')]")

    def actions_enabled?
      actions_element.click
      sleep 2
      return false unless actions_new_document_element.present?

      actions_element.click
      true
    end

    def open_documents_actions
      actions_element.click unless actions_new_document_element.present?

      @instance.webdriver.wait_until { actions_new_document_element.present? }
    end

    def actions_documents(action)
      open_documents_actions
      instance_eval("actions_#{action}_element.click", __FILE__, __LINE__) # choose action from documents menu
      return if (action == :upload_files) || (action == :upload_folders)

      @instance.webdriver.wait_until { file_currently_editing? }
    end

    def actions_upload_file(file_path)
      file_uploader_element.send_keys(file_path)
      @instance.webdriver.wait_until { !progress_bar_element.present? }
    end

    def upload_file_and_folder_button_present?
      actions_upload_files_element.present? && actions_upload_folders_element.present?
    end
  end
end
