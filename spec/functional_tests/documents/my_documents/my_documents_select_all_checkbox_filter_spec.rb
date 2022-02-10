# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create an upload files and folders to portal
document_name = "My_Document_#{SecureRandom.hex(7)}.docx"
spreadsheet_name = "My_Spreadsheet_#{SecureRandom.hex(7)}.xlsx"
presentation_name = "My_Presentation_#{SecureRandom.hex(7)}.pptx"
audio_name = "My_Audio_#{SecureRandom.hex(7)}.mp3"
archive_name = "My_Archive_#{SecureRandom.hex(7)}.zip"
picture_name = "My_Image_#{SecureRandom.hex(7)}.jpg"
all_files = [document_name, spreadsheet_name, presentation_name, audio_name, archive_name, picture_name]
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_by_folder_type(folder_name)
all_files_and_folders = all_files + [folder_name]

describe 'Documents filter My documents' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    api_admin.documents.delete_folders_by_title([folder_name])
    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @my_documents_page = main_page.main_page(:documents)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[My Documents] `Select all` checkbox works' do
    @my_documents_page.select_all_files
    expect(@my_documents_page).to be_files_checked(all_files_and_folders)
  end

  it '[My Documents] `Select all Documents` works' do
    @my_documents_page.select_files_filter(:documents)
    expect(@my_documents_page).to be_file_checked(document_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files_and_folders - [document_name])
  end

  it '[My Documents] `Select all Media` works' do
    @my_documents_page.select_files_filter(:media)
    expect(@my_documents_page).to be_file_checked(audio_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files_and_folders - [audio_name])
  end

  it '[My Documents] `Select all Presentations` works' do
    @my_documents_page.select_files_filter(:presentations)
    expect(@my_documents_page).to be_file_checked(presentation_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files_and_folders - [presentation_name])
  end

  it '[My Documents] `Select all Spreadsheets` works' do
    @my_documents_page.select_files_filter(:spreadsheets)
    expect(@my_documents_page).to be_file_checked(spreadsheet_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files_and_folders - [spreadsheet_name])
  end

  it '[My Documents] `Select all Files` works' do
    @my_documents_page.select_files_filter(:all_files)
    expect(@my_documents_page).to be_files_checked(all_files)
    expect(@my_documents_page).to be_all_files_not_checked([folder_name])
  end

  it '[My Documents] `Select all Images` works' do
    @my_documents_page.select_files_filter(:images)
    expect(@my_documents_page).to be_file_checked(picture_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files_and_folders - [picture_name])
  end

  it '[My Documents] `Select all Archives` works' do
    @my_documents_page.select_files_filter(:archives)
    expect(@my_documents_page).to be_file_checked(archive_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files_and_folders - [archive_name])
  end

  it '[My Documents] `Select all Folders` works' do
    @my_documents_page.select_files_filter(:folders)
    expect(@my_documents_page).to be_file_checked(folder_name)
    expect(@my_documents_page).to be_all_files_not_checked(all_files)
  end

  it '[My Documents] `Select all All` works' do
    @my_documents_page.select_files_filter(:all)
    expect(@my_documents_page).to be_files_checked(all_files_and_folders)
  end
end
