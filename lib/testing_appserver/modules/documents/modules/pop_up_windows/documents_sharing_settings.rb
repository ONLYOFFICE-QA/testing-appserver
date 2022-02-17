# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents Sharing Settings
  # https://user-images.githubusercontent.com/40513035/152301975-f12dc76e-d6cf-4f40-b202-e127c68200a5.png
  module DocumentsSharingSettings
    include PageObject
    # Share settings
    div(:plus_share, xpath: "//div[contains(@class, 'sharing_panel-plus-icon')]")
    div(:add_users, xpath: "//div[@label='Add users']") # add_id
    div(:add_groups, xpath: "//div[@label='Add groups']") # add_id
    button(:save_sharing, xpath: "//button[contains(@class, 'sharing_panel-button')]")

    # People Selector
    span(:people_selector_loading, xpath: "//span[contains(text(), 'Loading')]") # add_id
    div(:people_selector, xpath: "//div[contains(@class, 'options_list')]")
    button(:add_member, xpath: "//button[contains(@class, 'add_members_btn')]")

    def add_share_user(user_name)
      sleep 1
      plus_share_element.click
      @instance.webdriver.wait_until { add_users_element.present? }
      add_user(user_name)
      save_sharing_element.click
    end

    def add_user(user_name)
      add_users_element.click
      @instance.webdriver.wait_until { people_selector_element.present? }
      select_user(user_name)
      @instance.webdriver.wait_until { add_member_element.present? }
      add_member_element.click
      @instance.webdriver.wait_until { plus_share_element.present? }
    end

    def select_user(user_name)
      @instance.webdriver.wait_until { !people_selector_loading_element.present? }
      user_checkbox_xpath = "//span[@title='#{user_name}']/../../label"
      user_checkbox_element = @instance.webdriver.driver.find_element(:xpath, user_checkbox_xpath)
      user_checkbox_element.click
    end
  end
end
