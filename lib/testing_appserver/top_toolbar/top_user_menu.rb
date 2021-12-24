# frozen_string_literal: true

require_relative 'debug_info'

module TestingAppServer
  # AppServer top toolbar user menu
  # https://user-images.githubusercontent.com/40513035/147327305-b97a21e1-afee-45bb-b8be-c2b125f1702e.png
  module TopUserMenu
    include PageObject

    div(:owner_icon, xpath: "//div[contains(@class, 'icon-profile-menu')]")

    div(:debug_info, xpath: "//div[@label = 'Debug Info']") # add_id

    def top_user_menu(selected_item)
      unless debug_info_element.present?
        owner_icon_element.click
        @instance.webdriver.wait_until { debug_info_element.present? }
      end

      instance_eval("#{selected_item}_element.click", __FILE__, __LINE__) # choose module from tool bar profile menu
      case selected_item
      when :debug_info
        DebugInfo.new(@instance)
      end
    end

    def portal_version_and_build_date
      debug_window = top_user_menu(:debug_info)
      debug_window.version_and_build_date
    end
  end
end
