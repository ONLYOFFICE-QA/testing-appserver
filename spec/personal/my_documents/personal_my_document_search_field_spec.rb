# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

first_document = Tempfile.new(%w[New_Document .docx])
second_document = Tempfile.new(%w[New_Document .docx])
temp_docs = [first_document, second_document]

temp_docs.each do |file|
  TestingAppServer::SampleFilesLocation.copy_file_to_temp(file)
  api_admin.documents.upload_to_my_document(file.path)
end

describe 'Documents search field' do
  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after :all do
    api_admin.documents.delete_files_by_title(temp_docs)
  end

  after do
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it 'Search field works' do
    @documents_page.search_file(File.basename(first_document))
    expect(@documents_page).to be_file_present(File.basename(first_document))
  end
end
