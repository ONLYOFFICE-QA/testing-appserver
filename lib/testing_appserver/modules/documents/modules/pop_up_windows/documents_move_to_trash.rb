# frozen_string_literal: true

module TestingAppServer
  # AppServer Move To Trash(Delete) window
  # https://user-images.githubusercontent.com/40513035/169240332-d318e16e-9bc8-46bb-93d8-8e24927f32e8.png
  module DocumentsMoveToTrash
    include PageObject

    div(:move_to_trash, xpath: "//div[text()='Move to Trash']") # add_id
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
