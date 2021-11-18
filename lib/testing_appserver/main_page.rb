# frozen_string_literal: true

require_relative 'modules/documents/documents_module'
require_relative 'modules/people/people_module'
require_relative 'modules/settings/settings_module'
require_relative 'modules/module_place_holder'
require_relative 'top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer Main Page
  # https://user-images.githubusercontent.com/40513035/139641190-90056c14-8dac-4db7-a5f6-9834c3cd1e56.png
  class MainPage
    include TopToolbar
    include PageObject

    main_page_module = "//div[@class='home-modules']"
    link(:main_page_documents, xpath: "#{main_page_module}//a[contains(@href, 'files')]")
    link(:main_page_projects, xpath: "#{main_page_module}//a[contains(@href, 'projects')]")
    link(:main_page_calendar, xpath: "#{main_page_module}//a[contains(@href, 'calendar')]")
    link(:main_page_mail, xpath: "#{main_page_module}//a[contains(@href, 'mail')]")
    link(:main_page_crm, xpath: "#{main_page_module}//a[contains(@href, 'crm')]")
    link(:main_page_people, xpath: "#{main_page_module}//a[contains(@href, 'people')]")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { main_page_documents_element.present? }
    end

    def main_page(selected_module)
      instance_eval("main_page_#{selected_module}_element.click", __FILE__, __LINE__) # choose module from main page
      case selected_module
      when :documents
        DocumentsModule.new(@instance)
      when :people
        PeopleModule.new(@instance)
      when :settings
        SettingsModule.new(@instance)
      else
        ModulePlaceHolder.new(@instance, selected_module)
      end
    end

    def all_modules_present?
      main_page_documents_element.present? &&
        main_page_projects_element.present? &&
        main_page_calendar_element.present? &&
        main_page_mail_element.present? &&
        main_page_crm_element.present? &&
        main_page_people_element.present?
    end
  end
end