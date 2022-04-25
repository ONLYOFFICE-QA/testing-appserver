# frozen_string_literal: true

module TestingAppServer
  # AppServer Move To window
  # https://user-images.githubusercontent.com/40513035/154021462-4a22f427-954f-48f1-a9d0-70de3f53b2a9.png
  module DocumentsMoveTo
    include PageObject

    window_xpath = "//*[contains(@class,'modal-dialog-aside')]"
    span(:move_my_documents, xpath: "#{window_xpath}//li[contains(@class, 'tree-node-my')]/span[contains(@class, 'content')]")
    span(:move_common, xpath: "#{window_xpath}//li[contains(@class, 'tree-node-common')]/span[contains(@class, 'content')]")

    button(:confirm_move, xpath: "//button[text()='Move']")
    div(:moving_process_icon, xpath: "//div[contains(@class, 'layout-progress-bar')]")
    div(:success_move_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")

    def move_to_folder(folder)
      @instance.webdriver.wait_until { confirm_move_element.present? }
      if %i[common my_documents].include?(folder)
        instance_eval("move_#{folder}_element.click", __FILE__, __LINE__) # choose folder to move file
      else
        select_folder(folder)
      end
      confirm_move_element.click
      @instance.webdriver.wait_until { moving_process_icon_element.present? }
      OnlyofficeLoggerHelper.sleep_and_log('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56832', 3)
    end

    def select_folder(folder)
      folder_xpath = "//span[text()='#{folder}']"
      @instance.webdriver.driver.find_element(:xpath, folder_xpath).click
    end
  end
end
