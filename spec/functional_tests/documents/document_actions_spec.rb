# frozen_string_literal: true

require 'spec_helper'

admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
new_document = "New_Document_#{SecureRandom.hex(5)}"
new_spreadsheet = "New_Spreadsheet_#{SecureRandom.hex(5)}"
new_presentation = "New_Presentation_#{SecureRandom.hex(5)}"
new_folder = "New_Folder_#{SecureRandom.hex(5)}"

describe 'My Documents Actions menu' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @documents_page = main_page.side_bar(:documents)
  end

  after do |_example|
    @test.webdriver.quit
  end

  describe 'Document' do
    before do
      @documents_page.actions_documents(:new_document)
      @documents_page.add_name_to_file(new_document)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_document}.docx"))
    end

    it 'Created from Actions menu New Document exist in list of My Documents' do
      expect(api_admin.documents).to be_document_exist("#{new_document}.docx")
    end

    it 'Created from Actions menu New Document opens correctly in My Documents' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_document}.docx")
    end
  end

  describe 'Spreadsheet' do
    before do
      @documents_page.actions_documents(:new_spreadsheet)
      @documents_page.add_name_to_file(new_spreadsheet)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_spreadsheet}.xlsx"))
    end

    it 'Created from Actions menu New Spreadsheet exist in list of My Documents' do
      expect(api_admin.documents).to be_document_exist("#{new_spreadsheet}.xlsx")
    end

    it 'Created from Actions menu New Spreadsheet opens correctly in My Documents' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_spreadsheet}.xlsx")
    end
  end

  describe 'Presentation' do
    before do
      @documents_page.actions_documents(:new_presentation)
      @documents_page.add_name_to_file(new_presentation)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_presentation}.pptx"))
    end

    it 'Created from Actions menu New Presentation exist in list of My Documents' do
      expect(api_admin.documents).to be_document_exist("#{new_presentation}.pptx")
    end

    it 'Created from Actions menu New Presentation opens correctly in My Documents' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_presentation}.pptx")
    end
  end

  describe 'Folder' do
    after do
      api_admin.documents.delete_group(folders: api_admin.documents.id_by_folder_title(new_folder))
    end

    it 'Create New Folder from Actions menu' do
      @documents_page.actions_documents(:new_folder)
      @documents_page.add_name_to_file(new_folder)
      expect(api_admin.documents).to be_folder_exist(new_folder)
    end
  end
end
