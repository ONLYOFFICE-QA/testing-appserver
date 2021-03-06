# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

new_document = TestingAppServer::GeneralData.generate_random_name('New_Document')
new_spreadsheet = TestingAppServer::GeneralData.generate_random_name('New_Spreadsheet')
new_presentation = TestingAppServer::GeneralData.generate_random_name('New_Presentation')
all_files = %W[#{new_document}.docx #{new_spreadsheet}.xlsx #{new_presentation}.pptx]

# create recent files
main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
my_documents = main_page.top_toolbar(:documents)
my_documents.create_file_from_action(:new_document, new_document)
my_documents.create_file_from_action(:new_spreadsheet, new_spreadsheet)
my_documents.create_file_from_action(:new_presentation, new_presentation)
@test.webdriver.quit

describe 'Documents Recent' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    my_documents = main_page.top_toolbar(:documents)
    @recent = my_documents.documents_navigation(:recent)
  end

  after :all do
    api_admin.documents.delete_files_by_title(all_files)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it_behaves_like 'documents_recent_smoke', all_files

  it '[Recent] Search field Filters are present' do
    expect(@recent).to be_all_search_filters_for_recent_present
  end

  it '[Recent] All group filters fore Recent present: Share, Download, Download as, Copy' do
    @recent.check_file_checkbox(all_files[0])
    expect(@recent).to be_all_group_actions_for_resent_present
  end
end
