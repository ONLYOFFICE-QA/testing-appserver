# frozen_string_literal: true

module TestingAppServer
  # AppServer Move To window
  # https://user-images.githubusercontent.com/40513035/169239996-b3417b4b-156d-4dd2-bf1b-39663cf7fdc6.png
  module DocumentsMoveTo
    include PageObject

    window_xpath = "//*[contains(@class,'modal-dialog')]"
    span(:move_my_documents, xpath: "#{window_xpath}//li[contains(@class, 'tree-node-my')]/span[contains(@class, 'content')]")
    span(:move_common, xpath: "#{window_xpath}//li[contains(@class, 'tree-node-common')]/span[contains(@class, 'content')]")
    span(:my_documents_dropdown, xpath: "#{window_xpath}//div[contains(@class, 'tree-node-my')]/span[contains(@class, 'switcher')]")

    div(:confirm_move, xpath: "//div[text()='Move here']")
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
      my_documents_dropdown_element.click
      folder_xpath = "//span[text()='#{folder}']"
      @instance.webdriver.wait_until { @instance.webdriver.element_visible?(folder_xpath) }
      @instance.webdriver.driver.find_element(:xpath, folder_xpath).click
    end
  end
end
