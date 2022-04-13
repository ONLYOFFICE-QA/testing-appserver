# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
new_document = TestingAppServer::GeneralData.generate_random_name('New_Document')

describe 'Personal My Documents Actions menu' do
  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'Document' do
    before do
      @documents_page.create_file_from_action(:new_document, new_document)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_document}.docx"))
    end

    it '[Personal][My Documents] Created from Actions menu New Document exist in list' do
      expect(api_admin.documents).to be_document_exist("#{new_document}.docx")
    end

    it '[Personal][My Documents] Created from Actions menu New Document opens correctly' do
      expect(@documents_page.check_opened_file_name).to eq("#{new_document}.docx")
    end
  end
end
