# frozen_string_literal: true

require_relative 'documents_list_item_settings'
require_relative 'pop_up_windows/documents_sharing_settings'

module TestingAppServer
  # AppServer field in list of documents for creating and editing documents, spreadsheets, presentations and folders
  # https://user-images.githubusercontent.com/40513035/143570421-1286f0db-80ff-4f24-9dc5-a7520d01326f.png
  module DocumentsListItem
    include PageObject
    include DocumentsListItemSettings
    include DocumentsSharingSettings

    elements(:item_title, xpath: "//div[contains(@class, 'table-container_cell')]/a")

    image(:empty_folder, xpath: "//img[@alt='Empty folder image']") # add_id

    def file_present?(file_name)
      item_title_elements.each do |current_element|
        return true if @instance.webdriver.get_attribute(current_element, 'title').include?(file_name)
      end
      false
    end

    def file_copies_count(file_name)
      counter = 0
      item_title_elements.each do |current_element|
        counter += 1 if @instance.webdriver.get_attribute(current_element, 'title').include?(file_name)
      end
      counter
    end

    def files_present?(files)
      files.each do |file|
        return false unless file_present?(file)
      end
      true
    end

    def file_image_xpath(file_name)
      "//div[@data-title='#{file_name}' and contains(@class, 'files-item')]//div[contains(@class, 'element-wrapper')]"
    end

    def check_file_checkbox(file_name)
      @instance.webdriver.move_to_element_by_locator(file_image_xpath(file_name))
      @instance.webdriver.wait_until { file_checkbox_present?(file_name) }
      @instance.webdriver.driver.find_element(:xpath, file_checkbox_xpath(file_name)).click
    end

    def file_checkbox_xpath(file_name)
      "//div[@data-title='#{file_name}' and contains(@class, 'files-item')]//label[contains(@class, 'row-checkbox')]"
    end

    def file_checkbox_present?(file_name)
      @instance.webdriver.element_visible?(file_checkbox_xpath(file_name))
    end

    def files_checked?(files)
      files.each do |file|
        return false unless file_checkbox_present?(file)
      end
      true
    end

    def all_files_not_checked?(files)
      files.each do |file|
        return false if file_checkbox_present?(file)
      end
      true
    end

    def share_file(file_name, user_name)
      share_button_xpath = "//a[@title='#{file_name}']/../..//span[@title='Share']" # add_id
      @instance.webdriver.driver.find_element(:xpath, share_button_xpath).click
      add_share_user(user_name)
    end

    def folder_file_xpath(title)
      "//div[contains(@class, 'files-item')]/a[@title='#{title}']"
    end

    def open_folder(folder_title)
      @instance.webdriver.driver.find_element(:xpath, folder_file_xpath(folder_title)).click
      header_title = "//div[@class='header-container']//h1[text()='#{folder_title}']"
      @instance.webdriver.wait_until { @instance.webdriver.element_visible?(header_title) }
    end

    def file_version_xpath(title)
      "//a[@title='#{title}']/../..//div[contains(@class, 'badge-version')]"
    end

    def file_version(title)
      version_element = @instance.webdriver.driver.find_element(:xpath, file_version_xpath(title))
      @instance.webdriver.get_attribute(version_element, 'label').split('.')[-1].to_i
    end
  end
end
