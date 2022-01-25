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

new_document = "New_Document_#{SecureRandom.hex(5)}"
new_spreadsheet = "New_Spreadsheet_#{SecureRandom.hex(5)}"
new_presentation = "New_Presentation_#{SecureRandom.hex(5)}"
new_folder = "New_Folder_#{SecureRandom.hex(5)}"

describe 'Documents Common' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @common = main_page.top_toolbar(:documents).documents_navigation(:common)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'Actions' do
    describe 'Documents' do
      after do
        api_admin.documents.delete_group(files: api_admin.documents.common_id_by_title("#{new_document}.docx"))
      end

      it '[Common] New document exist for all users' do
        @common.create_file_from_action(:new_document, new_document)
        @test.webdriver.quit
        user_main_page, @test = TestingAppServer::AppServerHelper.new.init_instance(user)
        user_main_page.top_toolbar(:documents).documents_navigation(:common)
        expect(api_admin.documents).to be_common_document_exist("#{new_document}.docx")
      end
    end

    describe 'Spreadsheet' do
      after do
        api_admin.documents.delete_group(files: api_admin.documents.common_id_by_title("#{new_spreadsheet}.xlsx"))
      end

      it '[Common] New spreadsheet exist for all users' do
        @common.create_file_from_action(:new_spreadsheet, new_spreadsheet)
        @test.webdriver.quit
        user_main_page, @test = TestingAppServer::AppServerHelper.new.init_instance(user)
        user_main_page.top_toolbar(:documents).documents_navigation(:common)
        expect(api_admin.documents).to be_common_document_exist("#{new_spreadsheet}.xlsx")
      end
    end

    describe 'Presentation' do
      after do
        api_admin.documents.delete_group(files: api_admin.documents.common_id_by_title("#{new_presentation}.pptx"))
      end

      it '[Common] New presentation exist for all users' do
        @common.create_file_from_action(:new_presentation, new_presentation)
        @test.webdriver.quit
        user_main_page, @test = TestingAppServer::AppServerHelper.new.init_instance(user)
        user_main_page.top_toolbar(:documents).documents_navigation(:common)
        expect(api_admin.documents).to be_common_document_exist("#{new_presentation}.pptx")
      end
    end

    describe 'Folder' do
      after do
        api_admin.documents.delete_group(folders: api_admin.documents.common_id_by_folder_title(new_folder))
      end

      it '[Common] New Folder exist for all users' do
        @common.create_file_from_action(:new_folder, new_folder)
        @test.webdriver.quit
        user_main_page, @test = TestingAppServer::AppServerHelper.new.init_instance(user)
        user_main_page.top_toolbar(:documents).documents_navigation(:common)
        expect(api_admin.documents).to be_common_folder_exist(new_folder)
      end
    end

    it '[Common] Upload file and folder buttons visible' do
      @common.open_documents_actions
      expect(@common).to be_upload_file_and_folder_button_present
    end
  end
end
