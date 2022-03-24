# frozen_string_literal: true

require_relative '../modules/documents_navigation'
require_relative '../modules/pop_up_windows/connecting_account_sign_in'
require_relative '../../../top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer Connected Clouds page
  # https://user-images.githubusercontent.com/40513035/159625291-0fa30afe-65cf-4c83-94bb-423f143d668b.png
  class ConnectedClouds
    include PageObject
    include DocumentsNavigation
    include ConnectingAccountSignIn
    include TopToolbar

    link(:add_account, xpath: "//div[contains(@class, 'empty-folder_container')]//a[text()='Add account']") # add_id
    button(:connect_cloud, xpath: "//button[text()='Connected cloud']") # add_id

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { add_account_element.present? || connect_cloud_element.present? }
    end

    def account_is_present?(folder_title)
      folder_xpath = "//a[text()='#{folder_title}']"
      @instance.webdriver.element_visible?(folder_xpath)
    end
  end
end
