# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# add WebDav account
test = TestingAppServer::PersonalTestInstance.new(admin)
my_documents_page = TestingAppServer::PersonalSite.new(test).personal_login(admin.mail, admin.pwd)
webdav_data = TestingAppServer::GeneralData.documents_accounts[:webdav]
folder_title = TestingAppServer::GeneralData.generate_random_name('Account_folder')
_connected_clouds_page = my_documents_page.add_account('Webdav', webdav_data, folder_title)
test.webdriver.quit

describe 'Document file actions' do
  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @my_documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after :all do
    api_admin.documents.delete_group(folders: api_admin.documents.id_by_folder_title(folder_title))
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'WebDav' do
    it_behaves_like 'documents_account_creation', 'WebDav', folder_title,
                    TestingAppServer::GeneralData.webdav_accounts_files do
      let(:my_documents_page) { @my_documents_page }
    end
  end
end
