# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create an upload files and folders to portal
document_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
spreadsheet_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Spreadsheet')}.xlsx"
presentation_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Presentation')}.pptx"
audio_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Audio')}.mp3"
archive_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Archive')}.zip"
picture_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Image')}.jpg"
all_files = [document_name, spreadsheet_name, presentation_name, audio_name, archive_name, picture_name]

# create 2 files with the same names and different extensions
random_name = TestingAppServer::GeneralData.generate_random_name('My_File')
test_document = "#{random_name}.docx"
test_spreadsheet = "#{random_name}.xlsx"
test_files = [test_document, test_spreadsheet]

all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
test_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_by_folder_type(folder_name)
all_files_and_folders = all_files + [folder_name]

describe 'Documents filter for Personal' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
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

  it_behaves_like 'documents_select_all_checkbox', 'My Documents', all_files_and_folders, document_name,
                  spreadsheet_name, presentation_name, audio_name, archive_name, picture_name, folder_name, test_files do
    let(:documents_page) { @documents_page }
  end
end
