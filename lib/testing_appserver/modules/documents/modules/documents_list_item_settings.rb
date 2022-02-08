# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents List Item settings
  # https://user-images.githubusercontent.com/40513035/152883639-181ee5f8-093b-409b-bdcb-de3b611559c9.png
  module DocumentsListItemSettings
    include PageObject

    span(:setting_favorite, xpath: "//span[text() = 'Mark as favorite']") # add_id
    span(:setting_delete, xpath: "//span[text() = 'Delete']") # add_id

    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")
    element(:star_picture, xpath: "//*[contains(@class, 'favorite icons-group badge')]")

    def open_file_settings(file_name)
      settings_xpath = "//a[@title='#{file_name}']/../..//div[contains(@class, 'expandButton')]"
      @instance.webdriver.driver.find_element(:xpath, settings_xpath).click
      @instance.webdriver.wait_until { setting_delete_element.present? }
    end

    def mark_file_as_favorite(file_name)
      open_file_settings(file_name)
      setting_favorite_element.click
      @instance.webdriver.wait_until { success_toast_element.present? }
      success_toast_element.click # close notification toast to avoid hovering over other elements
      @instance.webdriver.wait_until { star_picture_element.present? }
    end
  end
end
