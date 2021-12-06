# frozen_string_literal: true

require_relative 'file_menu/file_menu'

module TestingAppServer
  # AppServer Documents file list element
  # https://user-images.githubusercontent.com/40513035/144541842-8c7bc3ac-4e8a-49ed-b63b-1a30b350813f.png
  module FileListElement
    include FileMenu

    def file_link(file_title)
      "(//a[@title='#{file_title}'])[1]"
    end

    def file_share(file_title)
      "#{file_link(file_title)}/../../../../..//span[@title='Share']" # add_id
    end

    def open_file_menu(file_title)
      file_menu_xpath = "#{file_link(file_title)}/../../../../..//div[contains(@class, 'expandButton')]" # add_id
      @instance.webdriver.switch_to_main_tab
      @instance.webdriver.driver.find_element(:xpath, file_menu_xpath).click
      @instance.webdriver.wait_until { delete_file_element.present? }
    end

    def delete_file_from_file_menu(file_title)
      open_file_menu(file_title)
      delete_file
    end
  end
end
