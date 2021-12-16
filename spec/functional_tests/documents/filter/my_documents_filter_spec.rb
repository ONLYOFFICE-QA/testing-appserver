# frozen_string_literal: true

require 'spec_helper'

admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
user = TestingAppServer::UserData.new(first_name: 'John', last_name: 'Smith',
                                      mail: TestingAppServer::PrivateData.new.decrypt['user_mail'],
                                      pwd: SecureRandom.hex(7), type: :user)
api_admin.people.add_user(user) unless api_admin.people.user_with_email_exist?(user.mail)

describe 'Documents filter My documents' do
  before :all do
    @files_array = [TestingAppServer::HelperFiles::DOCX, TestingAppServer::HelperFiles::MP3,
                    TestingAppServer::HelperFiles::ZIP, TestingAppServer::HelperFiles::PPTX,
                    TestingAppServer::HelperFiles::XLSX, TestingAppServer::HelperFiles::JPG]
    @files_array.each { |file| api_admin.documents.upload_to_my_document(TestingAppServer::HelperFiles::PATH_TO_FILE + file) }
    @folder_name = Faker::Hipster.word
    api_admin.documents.create_folder_in_my_documents(@folder_name)
    api_admin.documents.upload_to_folder(@folder_name,
                                         TestingAppServer::HelperFiles::PATH_TO_FILE + TestingAppServer::HelperFiles::DOCX_1)
    @admin_group = api_admin.people.add_group_with_manager_names(Faker::Food.fruits, manager: admin.full_name)
    @user_group = api_admin.people.add_group_with_manager_names(Faker::Food.vegetables, manager: user.full_name)
    @files_array.append(TestingAppServer::HelperFiles::DOCX_1)
  end

  after :all do
    api_admin.documents.delete_files_by_title(@files_array)
    api_admin.documents.delete_folders_by_title([@folder_name])
    api_admin.people.delete_groups([@admin_group['id'], @user_group['id']])
  end

  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @my_documents_page = main_page.main_page(:documents)
  end

  after do
    @test.webdriver.quit
  end

  describe 'Check filter My documents' do
    it_behaves_like 'docx_xlsx_pptx_users_groups_filter', 'My Documents', admin, user do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_img_media_archives_filter', 'My Documents' do
      let(:documents_page) { @my_documents_page }
    end

    it_behaves_like 'documents_folder_filter', 'My Documents' do
      let(:documents_page) { @my_documents_page }
    end
  end
end
