# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create files title
document_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
spreadsheet_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Spreadsheet')}.xlsx"
presentation_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Presentation')}.pptx"
archive_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Archive')}.zip"
picture_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Image')}.jpg"
audio_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Audio')}.mp3"
all_files = [document_name, spreadsheet_name, presentation_name, archive_name, picture_name, audio_name]

# upload files to temporary folder and portal
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end

# mark documents as favorite
@test = TestingAppServer::PersonalTestInstance.new(admin)
my_documents = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
all_files.each do |file|
  my_documents.file_settings(file, :favorite)
end
@test.webdriver.quit

describe 'Documents Favorites for Personal' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    my_documents = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
    @favorites = my_documents.documents_navigation(:favorites)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it_behaves_like 'documents_favorite_smoke', all_files

  it '[Personal][Favorites] Search field Filters are present' do
    expect(@favorites).to be_all_files_filters_present
  end

  it '[Personal][Favorites] All group actions present: Download, Download as, Copy, Delete' do
    @favorites.check_file_checkbox(document_name)
    expect(@favorites).to be_personal_all_group_actions_for_favorites_present
  end
end
