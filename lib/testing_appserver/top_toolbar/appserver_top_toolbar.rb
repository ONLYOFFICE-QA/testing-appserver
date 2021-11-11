# frozen_string_literal: true

require_relative 'appserver_side_bar'

module TestingAppServer
  # AppServer top toolbar
  # https://user-images.githubusercontent.com/40513035/141231154-94d2138a-f9e1-409c-9750-f300eca1094f.png
  module AppServerTopToolbar
    include AppServerSideBar
    include PageObject

    link(:top_logo, xpath: "//a[@class='header-logo-wrapper']")

    def home_top_logo
      top_logo_element.click
      AppServerMainPage.new(@instance)
    end
  end
end
