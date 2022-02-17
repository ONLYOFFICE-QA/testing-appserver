# frozen_string_literal: true

module TestingAppServer
  # AppServer Move To Trash(Delete) window
  # https://user-images.githubusercontent.com/40513035/154232964-f88cfdc7-0790-43b4-a0af-e7d46b5544cf.png
  module DocumentsMoveToTrash
    include PageObject

    button(:move_to_trash, xpath: "//button[text()='Move to Trash']") # add_id
    div(:deleting_process_icon, xpath: "//div[contains(@class, 'layout-progress-bar')]")
    div(:success_delete_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")

    def accept_deletion
      @instance.webdriver.wait_until { move_to_trash_element.present? }
      move_to_trash_element.click
      @instance.webdriver.wait_until { !deleting_process_icon_element.present? }
      @instance.webdriver.wait_until { success_delete_toast_element.present? }
      @instance.webdriver.wait_until { !success_delete_toast_element.present? }
    end
  end
end
