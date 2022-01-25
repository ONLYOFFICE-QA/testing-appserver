# frozen_string_literal: true

require_relative 'modules/documents/my_documents'
require_relative 'modules/people/people_module'
require_relative 'modules/settings/settings_module'
require_relative 'modules/module_place_holder'
require_relative 'top_toolbar/top_toolbar'

module TestingAppServer
  # AppServer Main Page
  # https://user-images.githubusercontent.com/40513035/150920766-4fdd517f-5424-421e-a05a-a4480a4c82b5.png
  class MainPage
    include TopToolbar
    include PageObject

    main_page_module = "//div[@class='home-modules']"
    div(:main_page_documents, xpath: "#{main_page_module}//div[contains(@data-link, 'files')]")
    div(:main_page_projects, xpath: "#{main_page_module}//div[contains(@data-link, 'Projects')]")
    div(:main_page_calendar, xpath: "#{main_page_module}//div[contains(@data-link, 'calendar')]")
    div(:main_page_mail, xpath: "#{main_page_module}//div[contains(@data-link, 'mail')]")
    div(:main_page_crm, xpath: "#{main_page_module}//div[contains(@data-link, 'CRM')]")
    div(:main_page_people, xpath: "#{main_page_module}//div[contains(@data-link, 'people')]")

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
        MyDocuments.new(@instance)
      when :people
        PeopleModule.new(@instance)
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
