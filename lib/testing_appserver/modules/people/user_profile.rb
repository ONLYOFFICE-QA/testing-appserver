# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/people_side_bar'
require_relative '../../data/user_data'

module TestingAppServer
  # AppServer People User profile
  # https://user-images.githubusercontent.com/40513035/142148957-cbae6dda-a69b-4ddf-8569-bda9c082aef8.png
  class UserProfile
    include PageObject
    include PeopleSideBar
    include TopToolbar

    button(:edit_profile, xpath: "//button[contains(@class, 'edit-profile-button')]")
    paragraph(:profile_email, xpath: "//div[contains(@class, 'section-wrapper-content')]//p")
    div(:profile_location, xpath: "//div[contains(@class, 'profile-info_location')]")
    h1(:profile_full_name_header, xpath: "//h1[contains(@class, 'header-headline')]")

    # profile actions menu
    div(:profile_actions_menu, xpath: "//div[contains(@class, 'hidingHeader')]//div[contains(@class, 'action-button')]")
    div(:profile_actions_disable, xpath: "//div[contains(@class, 'menu_disable')]")
    div(:profile_actions_delete, xpath: "//div[contains(@class, 'menu_delete-profile')]")
    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")
    button(:confirm_deletion, xpath: "//button[contains(@class, 'delete-profile_button-delete')]")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { profile_email_element.present? }
    end

    def profile_full_name
      profile_full_name_header_element.text
    end

    def profile_full_email
      profile_email_element.text
    end

    def profile_location
      profile_location_element.text
    end

    def delete_person_from_profile
      disable_user
      delete_user
    end

    def disable_user
      return if profile_disabled?

      open_profile_actions
      profile_actions_disable_element.click
      @instance.webdriver.wait_until { success_toast_element.present? }
    end

    def delete_user
      open_profile_actions
      profile_actions_delete_element.click
      @instance.webdriver.wait_until { confirm_deletion_element.present? }
      confirm_deletion_element.click
      @instance.webdriver.wait_until { success_toast_element.present? }
    end

    def profile_disabled?
      !edit_profile_element.present?
    end

    def open_profile_actions
      profile_actions_menu_element.click
      @instance.webdriver.wait_until { profile_actions_disable_element.present? || profile_actions_delete_element.present? }
    end

    def edit_user
      edit_profile_element.click
      UserCreationForm.new(@instance)
    end
  end
end
