# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

# api initialization
admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

# create 2 files with the same names and different extensions
random_name = TestingAppServer::GeneralData.generate_random_name('My_File')
document = "#{random_name}.docx"
spreadsheet = "#{random_name}.xlsx"
files = [document, spreadsheet]

files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end

describe 'Checkbox in Personal' do
  after :all do
    api_admin.documents.delete_files_by_title(files)
    files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it 'Select 2 files with the same name works' do
    @documents_page.check_file_checkbox(spreadsheet)
    expect(@documents_page).to be_file_checkbox_present(spreadsheet)
  end
end
