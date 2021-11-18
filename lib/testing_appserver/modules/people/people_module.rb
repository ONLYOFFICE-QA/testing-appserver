# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/people_side_bar'
require_relative 'user_creation_form'
require_relative 'user_profile'

module TestingAppServer
  # AppServer People module
  # https://user-images.githubusercontent.com/40513035/141245151-1fcad62a-9935-472d-a25d-513e10540a30.png
  class PeopleModule
    include PageObject
    include PeopleSideBar
    include TopToolbar

    div(:people_list, xpath: "//div[@id='table-container']")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { groups_link_element.present? && people_list_element.present? }
    end

    def user_not_exist?(full_name)
      @instance.webdriver.driver.find_elements(:xpath, user_element(full_name)).size.zero?
    end

    def user_element(full_name)
      "//a[@title='#{full_name}']"
    end

    def open_profile_by_full_name(full_name)
      @instance.webdriver.driver.find_element(:xpath, user_element(full_name)).click
      UserProfile.new(@instance)
    end
  end
end
