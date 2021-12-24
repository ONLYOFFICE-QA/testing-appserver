# frozen_string_literal: true

require_relative 'top_side_bar'
require_relative 'top_user_menu'

module TestingAppServer
  # AppServer top toolbar
  # https://user-images.githubusercontent.com/40513035/141231154-94d2138a-f9e1-409c-9750-f300eca1094f.png
  module TopToolbar
    include TopSideBar
    include TopUserMenu
    include PageObject

    link(:top_logo, xpath: "//a[@class='header-logo-wrapper']")

    def home_top_logo
      top_logo_element.click
      MainPage.new(@instance)
    end
  end
end
