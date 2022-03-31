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
main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
my_documents = main_page.top_toolbar(:documents)
all_files.each do |file|
  my_documents.file_settings(file, :favorite)
end
@test.webdriver.quit

describe 'Documents Favorites' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @favorites = main_page.top_toolbar(:documents).documents_navigation(:favorites)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Favorites] Actions menu button is disable' do
    expect(@favorites).not_to be_actions_enabled
  end

  it '[Favorites] All files marked as favorite are in `Favorite` folder' do
    expect(@favorites).to be_files_present(all_files)
  end

  it '[Favorites] `Select all` Filters are present' do
    expect(@favorites).to be_select_all_filters_for_favorites_present
  end

  it '[Favorites] Search field Filters are present' do
    expect(@favorites).to be_all_search_favorites_for_recent_present
  end

  it '[Favorites] All group actions present: Share, Download, Download as, Copy, Delete' do
    @favorites.check_file_checkbox(document_name)
    expect(@favorites).to be_all_group_actions_for_favorites_present
    expect(@favorites.group_menu_move_to_element).not_to be_present
  end
end
