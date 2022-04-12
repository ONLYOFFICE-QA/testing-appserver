# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

describe 'Personal My Documents File Menu' do
  before do
    @new_document = "#{TestingAppServer::GeneralData.generate_random_name('New_Document')}.docx"
    TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(@new_document)
    api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + @new_document)
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title(@new_document))
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'Document' do
    it '[Personal][File Menu] Edit file opens correct file' do
      expect(@documents_page.file_settings(@new_document, :edit)).to eq(@new_document)
    end

    it '[Personal][File Menu] Preview file opens correct file' do
      expect(@documents_page.file_settings(@new_document, :preview)).to eq(@new_document)
    end

    it '[Personal][File Menu] Share external link' do
      skip('Console error GET https://personal.teamlab.info/api/2.0/people/@self.json 401 when open external link')
      @documents_page.file_settings(@new_document, :sharing_settings)
      external_link = @documents_page.copy_external_link
      expect(@documents_page.open_external_link(external_link)).to eq(@new_document)
    end

    describe 'Version' do
      it '[Personal][File Menu] Finalize version appears lock' do
        @documents_page.file_settings(@new_document, :finalize_version)
        expect(@documents_page.file_version(@new_document)).to eq(2)
      end

      it '[Personal][File Menu] New version appears in version history' do
        @documents_page.file_settings(@new_document, :finalize_version)
        @documents_page.file_settings(@new_document, :version_history)
        expect(@documents_page).to be_version_is_present(2)
      end

      it '[Personal][File Menu] Download first version' do
        @documents_page.file_settings(@new_document, :version_history)
        @documents_page.download_version(1)
        expect(@documents_page).to be_file_downloaded(@new_document)
      end
    end

    it '[Personal][File Menu] Download button works' do
      @documents_page.file_settings(@new_document, :download)
      expect(@documents_page).to be_file_downloaded(@new_document)
    end

    describe 'Move or copy' do
      before do
        @folder_name = TestingAppServer::GeneralData.generate_random_name('Folder')
        api_admin.documents.create_folder_by_folder_type(@folder_name)
      end

      after { api_admin.documents.delete_folders_by_title([@folder_name]) }

      it '[Personal][File Menu] Move to button works' do
        @documents_page.file_settings(@new_document, :move_to, move_to_folder: @folder_name)
        expect(@documents_page).not_to be_file_present(@new_document)
        @documents_page.open_folder(@folder_name)
        expect(@documents_page).to be_file_present(@new_document)
      end

      it '[Personal][File Menu] Copy to button work' do
        @documents_page.file_settings(@new_document, :copy, copy_folder: @folder_name)
        expect(@documents_page).to be_file_present(@new_document)
        @documents_page.open_folder(@folder_name)
        expect(@documents_page).to be_file_present(@new_document)
      end

      it '[Personal][File Menu] Create a copy to button work' do
        @documents_page.file_settings(@new_document, :create_copy)
        expect(@documents_page).to be_file_copied(@new_document)
      end
    end

    it '[Personal][File Menu] Rename button works' do
      renamed_file = TestingAppServer::GeneralData.generate_random_name('New_Document')
      @documents_page.file_settings(@new_document, :rename, rename_file: renamed_file)
      expect(api_admin.documents).to be_document_exist("#{renamed_file}.docx")
    end

    it '[Personal][File Menu] Delete button works' do
      @documents_page.file_settings(@new_document, :delete)
      expect(@documents_page).not_to be_file_present(@new_document)
    end
  end
end
