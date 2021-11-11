# frozen_string_literal: true

require_relative '../../top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer People module
  # https://user-images.githubusercontent.com/40513035/141245151-1fcad62a-9935-472d-a25d-513e10540a30.png
  class PeopleModule
    include TopToolbar
    include PageObject

    link(:groups_link, xpath: "//a[@href='/products/people/filter']")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { groups_link_element.present? }
    end
  end
end
