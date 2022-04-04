# frozen_string_literal: true

module TestingAppServer
  # AppServer People module side bar
  # https://user-images.githubusercontent.com/40513035/141930474-c1456a9c-44a7-413e-ae09-d2a78e45f244.png
  module PeopleSideBar
    include PageObject

    element(:groups_menu, xpath: "//ul[contains(@class, 'people-tree-menu')]")

    # actions
    div(:actions, xpath: "(//div[contains(@class, 'people_main-button')])[1]")
    list_item(:actions_user, xpath: "//li[contains(@class, 'main-button_create-user')]")
    list_item(:actions_guest, xpath: "//li[contains(@class, 'main-button_create-guest')]")
    list_item(:actions_group, xpath: "//li[contains(@class, 'main-button_create-group')]")

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
