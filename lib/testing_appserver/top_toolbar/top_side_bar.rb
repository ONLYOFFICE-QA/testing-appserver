# frozen_string_literal: true

module TestingAppServer
  # AppServer side top toolbar menu
  # https://user-images.githubusercontent.com/40513035/140866725-74fad853-8c82-48e2-91e5-ff5a47a75a3e.png
  module TopSideBar
    include PageObject

    navigate_header = '//header[contains(@class, "navMenuHeader")]'

    link(:hamburger_icon, xpath: "#{navigate_header}/a[1]")

    link(:side_documents, xpath: "#{navigate_header}/..//a[@href = '/products/files/']")
    link(:side_people, xpath: "#{navigate_header}/..//a[@href = '/products/people/']")
    link(:side_settings, xpath: "#{navigate_header}/..//a[@href = '/settings']")
    link(:side_projects, xpath: "#{navigate_header}/..//a[@href = '/products/projects/']")
    link(:side_calendar, xpath: "#{navigate_header}/..//a[@href = '/products/calendar/']")
    link(:side_mail, xpath: "#{navigate_header}/..//a[@href = '/products/mail/']")
    link(:side_crm, xpath: "#{navigate_header}/..//a[@href = '/products/crm/']")

    def side_bar(selected_module)
      hamburger_icon_element.click unless side_documents_element.present?

      instance_eval("side_#{selected_module}_element.click", __FILE__, __LINE__) # choose module from side tool bar
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
  end
end
