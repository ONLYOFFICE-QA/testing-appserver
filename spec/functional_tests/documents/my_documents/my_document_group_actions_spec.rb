# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create an upload files and folders to portal
document_name = "My_Document_#{SecureRandom.hex(7)}.docx"
move_document = "My_Document_#{SecureRandom.hex(7)}.docx"
delete_document = "My_Document_#{SecureRandom.hex(7)}.docx"
all_files = [document_name, move_document, delete_document]
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_by_folder_type(folder_name)

describe 'Document file actions' do
  after :all do
    api_admin.documents.delete_files_by_title([document_name])
    api_admin.documents.delete_files_by_title([move_document, document_name], :common)
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

  it '[My Documents] `Download` group button works' do
    @my_documents_page.check_file_checkbox(document_name)
    @my_documents_page.group_menu_download_file
    expect(@my_documents_page).to be_file_downloaded(document_name)
  end

  it '[My Documents] `Share` group button opens Share window' do
    @my_documents_page.check_file_checkbox(document_name)
    @my_documents_page.group_menu_share_file
    expect(@my_documents_page.plus_share_element).to be_present
  end

  it '[My Documents] `Move to` Common group button works' do
    @my_documents_page.check_file_checkbox(move_document)
    @my_documents_page.group_menu_move_to(:common)
    expect(@my_documents_page).not_to be_file_present(move_document)
    common_documents = @my_documents_page.documents_navigation(:common)
    expect(common_documents).to be_file_present(move_document)
  end

  it '[My Documents] `Copy` to Common group button works' do
    @my_documents_page.check_file_checkbox(document_name)
    @my_documents_page.group_menu_copy_to(:common)
    expect(@my_documents_page).to be_file_present(document_name)
    common_documents = @my_documents_page.documents_navigation(:common)
    expect(common_documents).to be_file_present(document_name)
  end

  it '[My Documents] `Delete` group button works' do
    @my_documents_page.check_file_checkbox(delete_document)
    @my_documents_page.group_menu_delete
    expect(@my_documents_page).not_to be_file_present(delete_document)
  end

  it '[My Documents] All group filters fore Folder present: Share, Download, Move to, Copy, Delete' do
    @my_documents_page.check_file_checkbox(folder_name)
    expect(@my_documents_page).to be_all_group_actions_for_folder_present
    expect(@my_documents_page.group_menu_download_as_file_element).not_to be_present
  end
end
