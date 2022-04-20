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
document_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
document_name_folder = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
spreadsheet_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Spreadsheet')}.xlsx"
presentation_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Presentation')}.pptx"
archive_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Archive')}.zip"
picture_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Image')}.jpg"
audio_name = "#{TestingAppServer::GeneralData.generate_random_name('My_Audio')}.mp3"
all_files = [document_name, document_name_folder, spreadsheet_name, presentation_name, archive_name, picture_name, audio_name]
all_files.each { |file| TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file) }

# upload files to portal
(all_files - [document_name_folder]).each do |file|
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_by_folder_type(folder_name)
api_admin.documents.upload_to_folder(folder_name,
                                     TestingAppServer::SampleFilesLocation.path_to_tmp_file + document_name_folder)
admin_group = api_admin.people.add_group_with_manager_names(Faker::Food.fruits, manager: admin.full_name)
user_group = api_admin.people.add_group_with_manager_names(Faker::Food.vegetables, manager: user.full_name)

describe 'Documents filter My documents' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    api_admin.documents.delete_folders_by_title([folder_name])
    api_admin.people.delete_groups([admin_group['id'], user_group['id']])
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

  describe 'Check filter My documents' do
    it_behaves_like 'docx_xlsx_pptx_filter', 'My Documents', all_files, folder_name do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_users_groups_filter', 'My Documents', all_files, folder_name, admin, user,
                    admin_group, user_group do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_img_media_archives_filter', 'My Documents', all_files, folder_name do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_folder_filter', 'My Documents', all_files, folder_name, document_name,
                    document_name_folder do
      let(:documents_page) { @my_documents_page }
    end
  end
end
