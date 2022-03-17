# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents module side bar
  # https://user-images.githubusercontent.com/40513035/143567448-7678bdd2-8950-4551-98dd-490eff6cae8a.png
  module DocumentsActions
    include PageObject

    # actions
    div(:actions, xpath: "(//div[contains(@class, 'files-main-button')])[1]")
    list_item(:actions_new_document, xpath: "//li[contains(@class, 'main-button_new-document')]")
    list_item(:actions_new_spreadsheet, xpath: "//li[contains(@class, 'main-button_new-spreadsheet')]")
    list_item(:actions_new_presentation, xpath: "//li[contains(@class, 'main-button_new-presentation')]")
    list_item(:actions_new_folder, xpath: "//li[contains(@class, 'main-button_new-folder')]")
    list_item(:actions_upload_files, xpath: "//li[contains(@class, 'main-button_upload-files')]")
    list_item(:actions_upload_folders, xpath: "//li[contains(@class, 'main-button_upload-folders')]")
    text_field(:file_uploader, xpath: "//input[@id='customFileInput']")

    list_item(:actions_form_template, xpath: "//li[contains(@class, 'main-button_new-form')]")
    list_item(:actions_form_blank, xpath: "//li[contains(@class, 'main-button_new-form-from-blank')]")
    list_item(:actions_form_from_file, xpath: "//li[contains(@class, 'main-button_new-form-from-file')]")

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
      open_template_options if action.start_with?('form')
      instance_eval("actions_#{action}_element.click", __FILE__, __LINE__) # choose action from documents menu
      return if (action == :upload_files) || (action == :upload_folders) || (action == :form_from_file)

      @instance.webdriver.wait_until { file_currently_editing? }
    end

    def open_template_options
      actions_form_template_element.click
      @instance.webdriver.wait_until { actions_form_blank_element.present? }
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
