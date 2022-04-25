# frozen_string_literal: true

module TestingAppServer
  # AppServer Copy documents window
  # https://user-images.githubusercontent.com/40513035/154239428-075b5467-6bb5-4a88-a3bd-862d08bd24c8.png
  module DocumentsCopy
    include PageObject

    window_xpath = "//*[contains(@class,'modal-dialog-aside')]"
    span(:copy_to_my_documents, xpath: "#{window_xpath}//li[contains(@class, 'tree-node-my')]/span[contains(@class, 'content')]")
    span(:copy_to_common, xpath: "#{window_xpath}//li[contains(@class, 'tree-node-common')]/span[contains(@class, 'content')]")
    button(:confirm_copy, xpath: "#{window_xpath}//button[text()='Copy']") # add_id
    div(:loading_process, xpath: "//div[contains(@class, 'layout-progress-bar')]")
    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")

    def copy_to_folder(folder)
      @instance.webdriver.wait_until { copy_to_my_documents_element.present? }
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
      folder_xpath = "//span[text()='#{folder}']"
      @instance.webdriver.driver.find_element(:xpath, folder_xpath).click
    end
  end
end
