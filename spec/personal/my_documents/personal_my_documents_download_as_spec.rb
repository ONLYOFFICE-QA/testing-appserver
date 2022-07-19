# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
new_document = Tempfile.new(%w[New_Document .docx])
new_spreadsheet = Tempfile.new(%w[New_Spreadsheet .xlsx])
new_presentation = Tempfile.new(%w[New_Presentation .pptx])
all_files = [new_document, new_spreadsheet, new_presentation]
all_files_titles = []
all_files.each do |file|
  TestingAppServer::SampleFilesLocation.copy_file_to_temp(file)
  api_admin.documents.upload_to_my_document(file.path)
  all_files_titles << File.basename(file)
end

describe 'Personal My Documents Download As' do
  after :all do
    api_admin.documents.delete_files_by_title(all_files_titles)
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
        file_title = @documents_page.file_by_extension(all_files_titles, file_format)
        @documents_page.file_settings(file_title, :download_as, format: format_to_convert)
        expect(@documents_page).to be_file_downloaded(@documents_page.converted_file(file_title, file_format, format_to_convert))
      end
    end
  end
end
