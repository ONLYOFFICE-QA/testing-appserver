# frozen_string_literal: true

require_relative 'pop_up_windows/connecting_account_sign_in'

module TestingAppServer
  # AppServer Documents left side bar navigation module
  # https://user-images.githubusercontent.com/40513035/149236384-9e6fbd2f-fb94-4a6a-939c-b79b2c2f5ef8.png
  module DocumentsNavigation
    include PageObject
    include ConnectingAccountSignIn

    div(:my_documents_folder, xpath: "//div[contains (@class, 'tree-node-my')]")
    div(:shared_with_me_folder, xpath: "//div[contains (@class, 'tree-node-share')]")
    div(:favorites_folder, xpath: "//div[contains (@class, 'tree-node-favorites')]")
    div(:recent_folder, xpath: "//div[contains (@class, 'tree-node-recent')]")
    div(:private_room_folder, xpath: "//div[contains (@class, 'tree-node-privacy')]")
    div(:common_folder, xpath: "//div[contains (@class, 'tree-node-common')]")
    div(:trash_folder, xpath: "//div[contains (@class, 'tree-node-trash')]")

    # Settings
    list_item(:documents_settings_folder, xpath: "//li[contains(@class, 'tree-settings')]")
    list_item(:connected_clouds_folder, xpath: "//li[contains(@class, 'connected-clouds')]")

    div(:webdav_account, xpath: "//div[@data-key='WebDav']")
    div(:add_account_more, xpath: "//div[@class='tree-thirdparty-list']/div[contains(@class, 'icon')]")
    div(:cancel_add_account, xpath: "(//*[contains(@class, 'modal-dialog-aside ')]/div)[2]")

    def documents_navigation(folder)
      open_settings if folder == :connected_clouds
      instance_eval("#{folder}_folder_element.click", __FILE__, __LINE__) # choose action from documents menu

      case folder
      when :my_documents
        MyDocuments.new(@instance)
      when :shared_with_me
        DocumentsSharedWithMe.new(@instance)
      when :favorites
        DocumentsFavorites.new(@instance)
      when :recent
        DocumentsRecent.new(@instance)
      when :private_room
        DocumentsPrivateRoom.new(@instance)
      when :common
        DocumentsCommon.new(@instance)
      when :trash
        DocumentsTrash.new(@instance)
      when :connected_clouds
        ConnectedClouds.new(@instance)
      end
    end

    def open_settings
      documents_settings_folder_element.click unless connected_clouds_folder_element.visible?
    end

    def add_account(type, account_data, folder_title, common: false)
      if type == 'Webdav'
        webdav_account_element.click
      else
        choose_account_from_more(type)
      end
      send_account_form(account_data, folder_title, common)
      ConnectedClouds.new(@instance)
    end

    # there is no Settings -> Connected clouds link
    # it is possible navigate to Connected clouds by Account create canceling
    def open_connected_clouds_for_personal
      add_account_more_element.click
      @instance.webdriver.wait_until { cancel_add_account_element.present? }
      cancel_add_account_element.click
      ConnectedClouds.new(@instance)
    end

    def choose_account_from_more(type)
      add_account_more_element.click
      account_img_xpath = "//button[contains(@data-title, '#{type}')]"
      @instance.webdriver.wait_until { @instance.webdriver.element_visible?(account_img_xpath) }
      @instance.webdriver.driver.find_element(:xpath, account_img_xpath).click
    end
  end
end
