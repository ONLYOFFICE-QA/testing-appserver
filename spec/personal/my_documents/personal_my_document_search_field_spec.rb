# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

first_document = TestingAppServer::GeneralData.generate_random_name('New_Document')
second_document = TestingAppServer::GeneralData.generate_random_name('New_Document')

@test = TestingAppServer::PersonalTestInstance.new(admin)
my_documents = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
my_documents.create_file_from_action(:new_document, first_document)
my_documents.create_file_from_action(:new_document, second_document)
@test.webdriver.quit

describe 'Documents search field' do
  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after :all do
    api_admin.documents.delete_files_by_title(all_files)
  end

  after do
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it 'Search field works' do
    @documents_page.search_file(first_document)
    expect(@documents_page).to be_file_present(first_document)
  end
end
