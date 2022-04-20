# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
new_document = "#{TestingAppServer::GeneralData.generate_random_name('New_Document')}.docx"
new_spreadsheet = "#{TestingAppServer::GeneralData.generate_random_name('New_Spreadsheet')}.xlsx"
new_presentation = "#{TestingAppServer::GeneralData.generate_random_name('New_Presentation')}.pptx"
all_files = [new_document, new_spreadsheet, new_presentation]
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(file)
  api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + file)
end

describe 'Personal My Documents Download As' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files)
    all_files.each { |file| TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(file) }
  end

  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  TestingAppServer::GeneralData.download_formats.each do |file_format, formats_to_convert|
    formats_to_convert.each do |format_to_convert|
      it "[Personal][My Documents] Download `#{file_format}` as `#{format_to_convert}` works" do
        file_title = @documents_page.file_by_extension(all_files, file_format)
        @documents_page.file_settings(file_title, :download_as, format: format_to_convert)
        expect(@documents_page).to be_file_downloaded(@documents_page.converted_file(file_title, file_format, format_to_convert))
      end
    end
  end
end
