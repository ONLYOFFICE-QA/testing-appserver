# frozen_string_literal: true

require_relative 'debug_info'
require_relative 'about_this_program'

module TestingAppServer
  # AppServer top toolbar user menu
  # https://user-images.githubusercontent.com/40513035/147327305-b97a21e1-afee-45bb-b8be-c2b125f1702e.png
  module TopUserMenu
    include PageObject

    div(:owner_icon, xpath: "//div[contains(@class, 'icon-profile-menu')]")

    div(:debug_info, xpath: "//div[@label = 'Debug Info']") # add_id
    div(:about_this_program, xpath: "//div[@label='About this program']") # add_id
    div(:settings, xpath: "//div[@label='Settings']") # add_id
    div(:sign_out, xpath: "//div[@label='Sign Out']") # add_id

    def open_profile_menu
      return if debug_info_element.present?

      owner_icon_element.click
      @instance.webdriver.wait_until { sign_out_element.present? }
    end

    def select_from_profile_menu(selected_item)
      instance_eval("#{selected_item}_element.click", __FILE__, __LINE__) # choose module from tool bar profile menu
      case selected_item
      when :debug_info
        DebugInfo.new(@instance)
      when :about_this_program
        AboutThisProgram.new(@instance)
      when :settings
        SettingsModule.new(@instance)
      end
    end

    def top_user_menu(selected_item)
      open_profile_menu
      select_from_profile_menu(selected_item)
    end

    def portal_version_and_build_date
      debug_window = top_user_menu(:debug_info)
      debug_window.version_and_build_date
    end

    def portal_appserver_and_docs_version
      program_data = top_user_menu(:about_this_program)
      program_data.appserver_and_docs_version
    end
  end
end
