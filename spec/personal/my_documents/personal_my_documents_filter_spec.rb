# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

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

describe 'Documents filter My documents' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    api_admin.documents.delete_folders_by_title([folder_name])
    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @my_documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'Check filter My documents for Personal' do
    it_behaves_like 'docx_xlsx_pptx_filter', 'Personal', 'My Documents', all_files, folder_name do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_img_media_archives_filter', 'Personal', 'My Documents', all_files, folder_name do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_folder_filter', 'Personal', 'My Documents', all_files, folder_name, document_name,
                    document_name_folder do
      let(:documents_page) { @my_documents_page }
    end
  end
end
