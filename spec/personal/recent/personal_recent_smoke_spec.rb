# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

new_document = TestingAppServer::GeneralData.generate_random_name('New_Document')
new_spreadsheet = TestingAppServer::GeneralData.generate_random_name('New_Spreadsheet')
new_presentation = TestingAppServer::GeneralData.generate_random_name('New_Presentation')
all_files = ["#{new_document}.docx", "#{new_spreadsheet}.xlsx", "#{new_presentation}.pptx"]

# create recent files
@test = TestingAppServer::PersonalTestInstance.new(admin)
my_documents = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
my_documents.create_file_from_action(:new_document, new_document)
my_documents.create_file_from_action(:new_spreadsheet, new_spreadsheet)
my_documents.create_file_from_action(:new_presentation, new_presentation)
@test.webdriver.quit

describe 'Documents Recent' do
  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
    @recent = documents_page.documents_navigation(:recent)
  end

  after :all do
    api_admin.documents.delete_files_by_title(all_files)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it_behaves_like 'documents_recent_smoke', new_document, new_spreadsheet, new_presentation

  it '[AppServer][Recent] Search field Filters are present' do
    expect(@recent).to be_docx_xlsx_pptx_filters_present
  end

  it '[AppServer][Recent] All group filters fore Recent present: Download, Download as, Copy' do
    @recent.check_file_checkbox("#{new_document}.docx")
    expect(@recent).to be_download_copy_download_as_present
    expect(@recent.group_menu_share_file_element).not_to be_present
    expect(@recent.group_menu_move_to_element).not_to be_present
    expect(@recent.group_menu_delete_file_element).not_to be_present
  end
end
