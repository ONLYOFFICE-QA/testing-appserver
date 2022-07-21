# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents filter
  # https://user-images.githubusercontent.com/40513035/169212451-3ef333d8-0e43-4000-bb25-1c709ba233f7.png
  module DocumentsFilter
    include PageObject

    div(:open_filter, xpath: "(//div[contains(@class, 'section-header_filter')]/div/div)[2]")
    div(:close_filter, xpath: '//section/div[3]/div/div[3]/div[3]')

    # type filter
    div(:folders_filter, xpath: "//div[@name='folders-2']") # add_id
    div(:documents_filter, xpath: "//div[@name='documents-3']") # add_id
    div(:presentations_filter, xpath: "//div[@name='presentations-4']") # add_id
    div(:spreadsheets_filter, xpath: "//div[@name='spreadsheets-5']") # add_id
    div(:images_filter, xpath: "//div[@name='images-7']") # add_id
    div(:media_filter, xpath: "//div[@name='media-12']") # add_id
    div(:archives_filter, xpath: "//div[@name='archives-10']") # add_id
    div(:all_files_filter, xpath: "//div[@name='all files-1']") # add_id
    div(:no_subfolders_filter, xpath: "//*[text()='No subfolders']/following-sibling::div") # add_id
    div(:clear_filter, xpath: "//h1[text()='Filter']/following-sibling::div") # add_id

    div(:add_filter, xpath: "//div[text()='Add filter']") # add_id change_for_1_2

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
      open_filter_menu
      instance_eval("#{filter}_filter_element.click", __FILE__, __LINE__) # choose action from documents filter menu
      choose_group_filter(params[:group_name]) if params[:group_name]
      choose_user_filter(params[:user_name]) if params[:user_name]
      if filter == :clear
        close_filter_element.click
        OnlyofficeLoggerHelper.sleep_and_log('Wait to load search results', 2)
        return
      end
      add_filter_element.click
      @instance.webdriver.wait_until { !add_filter_element.present? }
      OnlyofficeLoggerHelper.sleep_and_log('Wait to load search results', 2)
    end

    def open_filter_menu
      open_filter_element.click
      @instance.webdriver.wait_until do
        documents_filter_element.present?
      end
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

    def all_search_filters_present?
      open_filter_menu
      documents_filters_present? && media_files_and_archives_filters_present? &&
        folders_files_subfolders_filters_present? && documents_user_and_groups_filters_present?
    end

    def docx_xlsx_pptx_filters_present?
      open_filter_menu
      documents_filters_present?
    end

    def all_files_filters_present?
      open_filter_menu
      documents_filters_present? && media_files_and_archives_filters_present? &&
        !documents_user_and_groups_filters_present? && !folders_files_subfolders_filters_present?
    end

    def all_search_filters_for_recent_present?
      open_filter_menu
      documents_filters_present? && documents_user_and_groups_filters_present?
    end

    def all_search_filters_for_favorites_present?
      open_filter_menu
      documents_filters_present? && media_files_and_archives_filters_present? &&
        documents_user_and_groups_filters_present?
    end

    def documents_filters_present?
      documents_filter_element.present? && presentations_filter_element.present? && spreadsheets_filter_element.present?
    end

    def documents_user_and_groups_filters_present?
      users_filter_element.present? && groups_filter_element.present?
    end

    def media_files_and_archives_filters_present?
      images_filter_element.present? && media_filter_element.present? && archives_filter_element.present?
    end

    def folders_files_subfolders_filters_present?
      folders_filter_element.present? && all_files_filter_element.present? && no_subfolders_filter_element.present?
    end
  end
end
