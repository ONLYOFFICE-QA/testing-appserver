# frozen_string_literal: true

module TestingAppServer
  # AppServer Connecting Account Sign In
  # https://user-images.githubusercontent.com/40513035/159439606-776e4b06-d352-4743-8491-5347b7a82fe4.png
  module ConnectingAccountSignIn
    include PageObject

    text_field(:account_url, xpath: "//label[text()='Connection url']/../..//input") # add_id
    text_field(:account_login, xpath: "//label[text()='Login']/../..//input") # add_id
    text_field(:account_pwd, xpath: "//input[@name='passwordInput']")
    text_field(:account_folder_title, xpath: "//label[text()='Folder title']/../..//input")
    text_field(:account_to_common, xpath: "//span[contains(text(), 'Common')]/../input")
    button(:account_save, xpath: "//button[text()='Save']")

    def send_account_form(account, folder_title, common)
      @instance.webdriver.wait_until { account_pwd_element.present? }
      fill_account_form(account, folder_title, common)
      account_save_element.click
      @instance.webdriver.wait_until { !account_pwd_element.present? }
    end

    def fill_account_form(account, folder_title, common)
      self.account_url = account[:url] if account[:url]
      self.account_login = account[:login]
      self.account_pwd = account[:pwd]
      self.account_folder_title = folder_title
      account_to_common_element.click if common
    end
  end
end
