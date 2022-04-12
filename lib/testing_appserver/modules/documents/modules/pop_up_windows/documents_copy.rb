# frozen_string_literal: true

module TestingAppServer
  # AppServer Copy documents window
  # https://user-images.githubusercontent.com/40513035/154239428-075b5467-6bb5-4a88-a3bd-862d08bd24c8.png
  module DocumentsCopy
    include PageObject

    window_xpath = "//*[contains(@class,'modal-dialog-aside')]"
    span(:copy_to_my_documents, xpath: "#{window_xpath}//span[@title ='My documents']") # add_id
    span(:copy_to_common, xpath: "#{window_xpath}//span[@title ='Common']") # add_id
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
      @instance.webdriver.wait_until { success_toast_element.present? }
      @instance.webdriver.wait_until { !success_toast_element.present? }
    end

    def select_folder(folder)
      folder_xpath = "//span[text()='#{folder}']"
      @instance.webdriver.driver.find_element(:xpath, folder_xpath).click
    end
  end
end
