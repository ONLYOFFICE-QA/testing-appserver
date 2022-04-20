# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create an upload files and folders to portal
document_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
move_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
delete_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
all_files = [document_name, move_document, delete_document]
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_by_folder_type(folder_name)

describe 'Personal Document file actions' do
  after :all do
    api_admin.documents.delete_files_by_title([document_name])
    api_admin.documents.delete_files_by_title([move_document, document_name], :common)
    api_admin.documents.delete_folders_by_title([folder_name])

    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it_behaves_like 'documents_group_actions', 'Personal', document_name, move_document, delete_document, folder_name do
    let(:documents_page) { @documents_page }
  end

  it '[Personal][My Documents] All group filters for document present' do
    @documents_page.check_file_checkbox(document_name)
    expect(@documents_page).to be_personal_group_actions_present
  end
end
