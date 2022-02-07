# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
user = TestingAppServer::UserData.new(first_name: 'John', last_name: 'Smith',
                                      mail: TestingAppServer::PrivateData.new.decrypt['user_mail'],
                                      pwd: TestingAppServer::PrivateData.new.decrypt['user_portal_pwd'], type: :user)
api_admin.people.add_user(user) unless api_admin.people.user_with_email_exist?(user.mail)

# create an upload files to temporary folder
document_name = "My_Document_#{SecureRandom.hex(7)}.docx"
document_name_folder = "My_Document_#{SecureRandom.hex(7)}.docx"
spreadsheet_name = "My_Spreadsheet_#{SecureRandom.hex(7)}.xlsx"
presentation_name = "My_Presentation_#{SecureRandom.hex(7)}.pptx"
archive_name = "My_Archive_#{SecureRandom.hex(7)}.zip"
picture_name = "My_Image_#{SecureRandom.hex(7)}.jpg"
audio_name = "My_Audio_#{SecureRandom.hex(7)}.mp3"
all_files = [document_name, spreadsheet_name, presentation_name, archive_name, picture_name, audio_name]
(all_files + [document_name_folder]).each { |file| TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file) }

# upload files to portal
all_files.each do |file|
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_in_my_documents(folder_name)
api_admin.documents.upload_to_folder(folder_name,
                                     TestingAppServer::SampleFilesLocation.path_to_tmp_file + document_name_folder)

# share documents
main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
my_documents = main_page.top_toolbar(:documents)
(all_files + [folder_name]).each do |file|
  my_documents.share_file(file, user.full_name)
end
@test.webdriver.quit

describe 'Documents Shared with me' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    api_admin.documents.delete_folders_by_title([folder_name])
    (all_files + [document_name_folder]).each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance(user)
    my_documents = main_page.top_toolbar(:documents)
    @shared_with_me = my_documents.documents_navigation(:shared_with_me)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Shared with me] Actions menu button is disable' do
    expect(@shared_with_me).not_to be_actions_enabled
  end

  it '[Shared with me] Shared documents and folders exist in Shared with me folder' do
    expect(@shared_with_me).to be_files_present(all_files + [folder_name])
  end

  it '[Shared with me] `Select all` Filters are present' do
    expect(@shared_with_me).to be_all_select_all_filters_present
  end

  it '[Shared with me] Search field Filters are present' do
    expect(@shared_with_me).to be_all_search_filters_present
  end
end
