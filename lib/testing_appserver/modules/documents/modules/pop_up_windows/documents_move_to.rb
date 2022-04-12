# frozen_string_literal: true

module TestingAppServer
  # AppServer Move To window
  # https://user-images.githubusercontent.com/40513035/154021462-4a22f427-954f-48f1-a9d0-70de3f53b2a9.png
  module DocumentsMoveTo
    include PageObject

    list_item(:move_my_documents, xpath: "(//li[contains(@class, 'tree-node-my')])[2]/span[contains(@class, 'content')]")
    list_item(:move_common, xpath: "(//li[contains(@class, 'tree-node-common')])[2]/span[contains(@class, 'content')]") # add_id

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
      @instance.webdriver.wait_until { success_move_toast_element.present? }
      @instance.webdriver.wait_until { !success_move_toast_element.present? }
    end

    def select_folder(folder)
      folder_xpath = "//span[text()='#{folder}']"
      @instance.webdriver.driver.find_element(:xpath, folder_xpath).click
    end
  end
end
