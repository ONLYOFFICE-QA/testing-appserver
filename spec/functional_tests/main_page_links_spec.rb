# frozen_string_literal: true

require 'spec_helper'

main_page, test = TestingAppServer::AppServerHelper.new.init_instance
version, build_date = main_page.portal_version_and_build_date
test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__), version: version, build_date: build_date)
test.webdriver.quit

describe 'Main page links' do
  before do
    @main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it 'All modules on main page present' do
    expect(@main_page).to be_all_modules_present
  end

  describe 'Side bar modules' do
    it 'Documents module opens correctly from side bar' do
      documents_page = @main_page.side_bar(:documents)
      expect(documents_page).to be_a(TestingAppServer::MyDocuments)
    end

    it 'People module opens correctly from side bar' do
      people_page = @main_page.side_bar(:people)
      expect(people_page).to be_a(TestingAppServer::PeopleModule)
    end

    it 'Settings module opens correctly from side bar' do
      settings_page = @main_page.side_bar(:settings)
      expect(settings_page).to be_a(TestingAppServer::SettingsModule)
    end

    it 'Projects place holder opens correctly from side bar' do
      projects_page = @main_page.side_bar(:projects)
      expect(projects_page).to be_selected_module_picture_present(:projects)
    end

    it 'Calendar place holder opens correctly from side bar' do
      calendar_page = @main_page.side_bar(:calendar)
      expect(calendar_page).to be_selected_module_picture_present(:calendar)
    end

    it 'Mail place holder opens correctly from side bar' do
      mail_page = @main_page.side_bar(:mail)
      expect(mail_page).to be_selected_module_picture_present(:mail)
    end

    it 'CRM place holder opens correctly from side bar' do
      crm_page = @main_page.side_bar(:crm)
      expect(crm_page).to be_selected_module_picture_present(:crm)
    end
  end

  describe 'Main page modules' do
    it 'Documents module opens correctly from main page' do
      documents_page = @main_page.main_page(:documents)
      expect(documents_page).to be_a(TestingAppServer::MyDocuments)
    end

    it 'People module opens correctly from main page' do
      people_page = @main_page.main_page(:people)
      expect(people_page).to be_a(TestingAppServer::PeopleModule)
    end

    it 'Projects place holder opens correctly from main page' do
      projects_page = @main_page.main_page(:projects)
      expect(projects_page).to be_selected_module_picture_present(:projects)
    end

    it 'Calendar place holder opens correctly from main page' do
      calendar_page = @main_page.main_page(:calendar)
      expect(calendar_page).to be_selected_module_picture_present(:calendar)
    end

    it 'Mail place holder opens correctly from main page' do
      mail_page = @main_page.main_page(:mail)
      expect(mail_page).to be_selected_module_picture_present(:mail)
    end

    it 'CRM place holder opens correctly from main page' do
      crm_page = @main_page.main_page(:crm)
      expect(crm_page).to be_selected_module_picture_present(:crm)
    end
  end
end
