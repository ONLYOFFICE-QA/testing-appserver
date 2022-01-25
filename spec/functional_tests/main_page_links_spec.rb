# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

describe 'Main page links' do
  before do
    @main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'Top toolbar modules' do
    it 'All modules on top toolbar present' do
      expect(@main_page).to be_all_top_toolbar_modules_present
    end

    it 'Documents module opens correctly from side bar' do
      documents_page = @main_page.top_toolbar(:documents)
      expect(documents_page).to be_a(TestingAppServer::MyDocuments)
    end

    it 'People module opens correctly from side bar' do
      people_page = @main_page.top_toolbar(:people)
      expect(people_page).to be_a(TestingAppServer::PeopleModule)
    end

    it 'Settings module opens correctly from user menu' do
      settings_page = @main_page.top_user_menu(:settings)
      expect(settings_page).to be_a(TestingAppServer::SettingsModule)
    end
  end

  describe 'Main page modules' do
    it 'All modules on main page present' do
      expect(@main_page).to be_all_modules_present
    end

    it 'Documents module opens correctly from main page' do
      documents_page = @main_page.main_page(:documents)
      expect(documents_page).to be_a(TestingAppServer::MyDocuments)
    end

    it 'People module opens correctly from main page' do
      people_page = @main_page.main_page(:people)
      expect(people_page).to be_a(TestingAppServer::PeopleModule)
    end
  end
end
