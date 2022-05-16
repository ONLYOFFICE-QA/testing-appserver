# frozen_string_literal: true

require_relative 'top_user_menu'

module TestingAppServer
  # AppServer top toolbar
  # https://user-images.githubusercontent.com/40513035/150917997-a59a804d-753f-45b5-8a38-59f775a11ab1.png
  module TopToolbar
    include TopUserMenu
    include PageObject

    link(:top_logo, xpath: "//a[@class='header-logo-wrapper']")

    top_toolbar_xpath = "//div[contains (@class, 'header-items-wrapper')]"

    link(:top_toolbar_documents, xpath: "#{top_toolbar_xpath}/a[@href = '/products/files/']")
    link(:top_toolbar_people, xpath: "#{top_toolbar_xpath}/a[@href = '/products/people/']")
    link(:top_toolbar_projects, xpath: "#{top_toolbar_xpath}/a[@href = '/products/projects/']")
    link(:top_toolbar_calendar, xpath: "#{top_toolbar_xpath}/a[@href = '/products/calendar/']")
    link(:top_toolbar_mail, xpath: "#{top_toolbar_xpath}/a[@href = '/products/mail/']")
    link(:top_toolbar_crm, xpath: "#{top_toolbar_xpath}/a[@href = '/products/crm/']")

    def top_toolbar(selected_module)
      instance_eval("top_toolbar_#{selected_module}_element.click", __FILE__, __LINE__) # choose module from side tool bar
      case selected_module
      when :documents
        MyDocuments.new(@instance)
      when :people
        PeopleModule.new(@instance)
      end
    end

    def home_top_logo
      top_logo_element.click
      MainPage.new(@instance)
    end

    def all_top_toolbar_modules_present?
      all_top_toolbar_modules_navigation_present? &&
        owner_icon_element.present?
    end

    def all_top_toolbar_modules_navigation_present?
      top_toolbar_documents_element.present? &&
        top_toolbar_people_element.present? &&
        top_toolbar_projects_element.present? &&
        top_toolbar_calendar_element.present? &&
        top_toolbar_mail_element.present? &&
        top_toolbar_crm_element.present?
    end
  end
end
