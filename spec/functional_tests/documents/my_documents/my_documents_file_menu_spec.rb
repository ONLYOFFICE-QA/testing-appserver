# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

new_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
version_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
move_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Move')}.docx"
copy_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Copy')}.docx"
create_copy_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Create_Copy')}.docx"
rename_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Rename')}.docx"
delete_document = "#{TestingAppServer::GeneralData.generate_random_name('My_Document')}.docx"
all_files = [new_document, version_document, move_document, copy_document, create_copy_document, rename_document, delete_document]
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end
folder_name = Faker::Hipster.word
api_admin.documents.create_folder_by_folder_type(folder_name)

describe 'My Documents File Menu' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @documents_page = main_page.top_toolbar(:documents)
  end

  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    api_admin.documents.delete_folders_by_title([folder_name])
    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it_behaves_like 'documents_file_menu', 'AppServer', 'My Documents', api_admin, new_document, version_document,
                  move_document, copy_document, create_copy_document, rename_document, delete_document, folder_name do
    let(:documents_page) { @documents_page }
  end
end
