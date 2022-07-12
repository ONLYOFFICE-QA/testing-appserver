# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create temp files
document = Tempfile.new(%w[My_Document .docx])
spreadsheet = Tempfile.new(%w[My_Spreadsheet .xlsx])
presentation = Tempfile.new(%w[My_presentation .pptx])
archive = Tempfile.new(%w[My_archive .zip])
picture = Tempfile.new(%w[My_Image .jpg])
audio = Tempfile.new(%w[My_audio .mp3])

all_files = [document, spreadsheet, presentation, archive, picture, audio]

# upload files to temporary folder and portal
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(File.path(file))
end

# mark documents as favorite
@test = TestingAppServer::PersonalTestInstance.new(admin)
my_documents = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
all_files.each do |file|
  my_documents.file_settings(File.basename(file), :favorite)
end

# create array with file names
all_files.map! do |tempfile|
  File.basename(tempfile)
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
    @favorites.check_file_checkbox(all_files[0])
    expect(@favorites).to be_personal_all_group_actions_for_favorites_present
  end
end
