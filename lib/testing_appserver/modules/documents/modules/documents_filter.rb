# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents filter
  # https://user-images.githubusercontent.com/40513035/145948844-ed1b4a67-0a0c-42e7-9daa-36f26ac4eaf5.png
  module DocumentsFilter
    include PageObject

    div(:add_filter, xpath: "//div[contains(@class,'section-header_filter')]//div[@id='filter-button']")

    # type filter
    div(:folders_filter, xpath: "(//div[@label='Folders'])[1]") # add_id
    div(:documents_filter, xpath: "//div[@label='Documents']") # add_id
    div(:presentations_filter, xpath: "//div[@label='Presentations']") # add_id
    div(:spreadsheets_filter, xpath: "//div[@label='Spreadsheets']") # add_id
    div(:images_filter, xpath: "//div[@label='Images']") # add_id
    div(:media_filter, xpath: "//div[@label='Media']") # add_id
    div(:archives_filter, xpath: "//div[@label='Archives']") # add_id
    div(:all_files_filter, xpath: "//div[@label='All files']") # add_id
    div(:no_subfolders_filter, xpath: "//div[@label='No subfolders']") # add_id

    # user filter
    div(:users_filter, xpath: "//div[@label='Users']") # add_id
    text_field(:users_filter_search, xpath: "//input[@placeholder='Search users']") # add_id
    span(:users_group_loading, xpath: "//span[text()='Loading... Please wait...']") # add_id

    # group filter
    div(:groups_filter, xpath: "//div[@label='Groups']") # add_id
    text_field(:groups_filter_search, xpath: "//input[@placeholder='Search groups']") # add_id

    text_field(:query_field, xpath: "//div[contains(@class,'section-header_filter')]//input[@placeholder='Search']")

    link(:reset_filter, xpath: "//a[text()='Reset filter']") # add_id

    def set_filter(filter, params = {})
      add_filter_element.click
      @instance.webdriver.wait_until do
        all_files_filter_element.present?
      end
      instance_eval("#{filter}_filter_element.click", __FILE__, __LINE__) # choose action from documents filter menu
      choose_group_filter(params[:group_name]) if params[:group_name]
      choose_user_filter(params[:user_name]) if params[:user_name]
      sleep 2 # wait to load search results
    end

    def selected_group_user_xpath(group_name)
      "//div[contains(@class, 'body-options')]//a[text()='#{group_name}']"
    end

    def choose_group_filter(group_name)
      @instance.webdriver.wait_until { groups_filter_search_element.present? }
      self.groups_filter_search = group_name
      wait_group_user_search_to_load
      @instance.webdriver.driver.find_element(:xpath, selected_group_user_xpath(group_name)).click
    end

    def choose_user_filter(user_name)
      @instance.webdriver.wait_until { users_filter_search_element.present? }
      self.users_filter_search = user_name
      user_name = 'Me' if user_name == @instance.user.full_name
      wait_group_user_search_to_load
      @instance.webdriver.driver.find_element(:xpath, selected_group_user_xpath(user_name)).click
    end

    def wait_group_user_search_to_load
      @instance.webdriver.wait_until { !users_group_loading_element.present? }
    end

    def nothing_found?
      reset_filter_element.present?
    end

    def fill_filter(value)
      self.query_field = value
      sleep 2 # wait to load search results
    end
  end
end
