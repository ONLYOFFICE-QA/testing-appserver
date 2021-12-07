# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents module side bar
  # https://user-images.githubusercontent.com/40513035/143567448-7678bdd2-8950-4551-98dd-490eff6cae8a.png
  module DocumentsSideBar
    include PageObject

    # actions
    div(:actions, xpath: "(//div[contains(@class, 'files_main-button')])[1]")
    div(:actions_new_document, xpath: "//div[contains(@class, 'main-button_new-document')]")
    div(:actions_new_spreadsheet, xpath: "//div[contains(@class, 'main-button_new-spreadsheet')]")
    div(:actions_new_presentation, xpath: "//div[contains(@class, 'main-button_new-presentation')]")
    div(:actions_new_folder, xpath: "//div[contains(@class, 'main-button_new-folder')]")
    div(:actions_upload_files, xpath: "//div[contains(@class, 'main-button_upload-files')]")
    div(:actions_upload_folders, xpath: "//div[contains(@class, ' main-button_upload-folders')]")

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
  end
end
