# frozen_string_literal: true

require 'spec_helper'

describe 'Main page links' do
  before do
    @main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
  end

  after do |_example|
    @test.webdriver.quit
  end

  it 'All modules on main page present' do
    expect(@main_page).to be_all_modules_present
  end

  it 'All side bar modules open correctly' do
    documents_page = @main_page.side_bar(:documents)
    expect(documents_page).to be_a TestingAppServer::AppServerDocuments
    people_page = documents_page.side_bar(:people)
    expect(people_page).to be_a TestingAppServer::AppServerPeople
    settings_page = people_page.side_bar(:settings)
    expect(settings_page).to be_a TestingAppServer::AppServerSettings
    projects_page = settings_page.side_bar(:projects)
    expect(projects_page).to be_selected_module_picture_present(:projects)
    calendar_page = projects_page.side_bar(:calendar)
    expect(calendar_page).to be_selected_module_picture_present(:calendar)
    mail_page = calendar_page.side_bar(:mail)
    expect(mail_page).to be_selected_module_picture_present(:mail)
    crm_page = mail_page.side_bar(:crm)
    expect(crm_page).to be_selected_module_picture_present(:crm)
  end

  it 'All main page modules open correctly' do
    documents_page = @main_page.main_page(:documents)
    expect(documents_page).to be_a TestingAppServer::AppServerDocuments
    people_page = documents_page.home_top_logo.main_page(:people)
    expect(people_page).to be_a TestingAppServer::AppServerPeople
    projects_page = people_page.home_top_logo.main_page(:projects)
    expect(projects_page).to be_selected_module_picture_present(:projects)
    calendar_page = projects_page.home_top_logo.main_page(:calendar)
    expect(calendar_page).to be_selected_module_picture_present(:calendar)
    mail_page = calendar_page.home_top_logo.main_page(:mail)
    expect(mail_page).to be_selected_module_picture_present(:mail)
    crm_page = mail_page.home_top_logo.main_page(:crm)
    expect(crm_page).to be_selected_module_picture_present(:crm)
  end
end
