# frozen_string_literal: true

module TestingAppServer
  # AppServer People module side bar
  # https://user-images.githubusercontent.com/40513035/141930474-c1456a9c-44a7-413e-ae09-d2a78e45f244.png
  module PeopleSideBar
    include PageObject

    link(:groups_link, xpath: "//span[@class='rc-tree-title']/a[contains(text(), 'Groups')]") # add_id

    # actions
    div(:actions, xpath: "(//div[contains(@class, 'main-button')])[1]")
    span(:actions_user, xpath: "//span[text()='User']") # add_id
    span(:actions_guest, xpath: "//span[text()='Guest']") # add_id
    span(:actions_group, xpath: "//span[text()='Group']") # add_id

    def open_people_actions
      actions_element.click unless actions_user_element.present?

      @instance.webdriver.wait_until { actions_user_element.present? }
    end

    def open_create_user_form_from_side_bar
      open_people_actions
      actions_user_element.click
      UserCreationForm.new(@instance)
    end
  end
end
