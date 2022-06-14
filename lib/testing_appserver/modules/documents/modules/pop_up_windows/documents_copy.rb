# frozen_string_literal: true

module TestingAppServer
  # AppServer Copy documents window
  # https://user-images.githubusercontent.com/40513035/169239888-bf3b955a-6584-45c7-9e68-3c96a071fdad.png
  module DocumentsCopy
    include PageObject

    window_xpath = "//*[contains(@class,'selection-panel')]"
    span(:copy_to_my_documents, xpath: "#{window_xpath}///div[contains(@class, 'tree-node-my')]/span[contains(@class, 'content')]")
    span(:copy_to_common, xpath: "#{window_xpath}//div[contains(@class, 'tree-node-common')]/span[contains(@class, 'content')]")
    span(:my_documents_dropdown, xpath: "#{window_xpath}//div[contains(@class, 'tree-node-my')]/span[contains(@class, 'switcher')]")

    button(:confirm_copy, xpath: "//button[contains(@class, 'select-file-modal-dialog-buttons-save')]")
    div(:loading_process, xpath: "//div[contains(@class, 'layout-progress-bar')]")
    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")

    def copy_to_folder(folder)
      @instance.webdriver.wait_until { confirm_copy_element.present? }
      if %i[common my_documents].include?(folder)
        instance_eval("copy_to_#{folder}_element.click", __FILE__, __LINE__) # choose folder to move file
      else
        select_folder(folder)
      end
      confirm_copy_element.click
      @instance.webdriver.wait_until { loading_process_element.present? }
      OnlyofficeLoggerHelper.sleep_and_log('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56832', 3)
    end

    def select_folder(folder)
      my_documents_dropdown_element.click
      folder_xpath = "//span[text()='#{folder}']"
      @instance.webdriver.wait_until { @instance.webdriver.element_visible?(folder_xpath) }
      @instance.webdriver.driver.find_element(:xpath, folder_xpath).click
    end
  end
end
