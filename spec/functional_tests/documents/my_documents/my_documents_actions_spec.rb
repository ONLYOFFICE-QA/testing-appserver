# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
new_document = "New_Document_#{SecureRandom.hex(5)}"
new_spreadsheet = "New_Spreadsheet_#{SecureRandom.hex(5)}"
new_presentation = "New_Presentation_#{SecureRandom.hex(5)}"
new_folder = "New_Folder_#{SecureRandom.hex(5)}"
new_form_blank = "New_Form_Blank_#{SecureRandom.hex(5)}"
new_form_document = "New_Document_#{SecureRandom.hex(5)}"
new_form_fom_file = "New_Form_From_File_#{SecureRandom.hex(5)}"

describe 'My Documents Actions menu' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @documents_page = main_page.top_toolbar(:documents)
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

    it '[My Documents] Created from Actions menu New Document exist in list' do
      expect(api_admin.documents).to be_document_exist("#{new_document}.docx")
    end

    it '[My Documents] Created from Actions menu New Document opens correctly' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_document}.docx")
    end
  end

  describe 'Spreadsheet' do
    before do
      @documents_page.create_file_from_action(:new_spreadsheet, new_spreadsheet)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_spreadsheet}.xlsx"))
    end

    it '[My Documents] Created from Actions menu New Spreadsheet exist in list' do
      expect(api_admin.documents).to be_document_exist("#{new_spreadsheet}.xlsx")
    end

    it '[My Documents] Created from Actions menu New Spreadsheet opens correctly' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_spreadsheet}.xlsx")
    end
  end

  describe 'Presentation' do
    before do
      @documents_page.create_file_from_action(:new_presentation, new_presentation)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_presentation}.pptx"))
    end

    it '[My Documents] Created from Actions menu New Presentation exist in list' do
      expect(api_admin.documents).to be_document_exist("#{new_presentation}.pptx")
    end

    it '[My Documents] Created from Actions menu New Presentation opens correctly' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_presentation}.pptx")
    end
  end

  describe 'Form Template Blank' do
    before do
      @documents_page.create_file_from_action(:form_blank, new_form_blank)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_form_blank}.docxf"))
    end

    it '[My Documents] Created from Actions menu Blank Form template exist in list' do
      expect(api_admin.documents).to be_document_exist("#{new_form_blank}.docxf")
    end

    it '[My Documents] Created from Actions menu Blank Form template opens correctly' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_form_blank}.docxf")
    end
  end

  describe 'Form Template From File' do
    before do
      TestingAppServer::SampleFilesLocation.upload_to_tmp_folder("#{new_form_document}.docx")
      api_admin.documents.upload_to_my_document(TestingAppServer::SampleFilesLocation.path_to_tmp_file + "#{new_form_document}.docx")
      @documents_page.create_file_from_action(:form_from_file, new_form_fom_file, new_form_document)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_form_fom_file}.docxf"))
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{new_form_document}.docx"))
    end

    it '[My Documents] Created from Actions menu Form Template From File exist in list' do
      pending('500 (Internal Server Error) for Form Template From File creation')
      expect(api_admin.documents).to be_document_exist("#{new_form_fom_file}.docxf")
    end

    it '[My Documents] Created from Actions menu Form Template From File opens correctly' do
      skip('Console errors in the document page')
      expect(@documents_page.check_opened_file_name).to eq("#{new_form_fom_file}.docxf")
    end
  end

  describe 'Folder' do
    after do
      api_admin.documents.delete_group(folders: api_admin.documents.id_by_folder_title(new_folder))
    end

    it '[My Documents] Create New Folder from Actions menu' do
      @documents_page.create_file_from_action(:new_folder, new_folder)
      expect(api_admin.documents).to be_folder_exist(new_folder)
    end
  end

  describe 'File Upload' do
    before do
      @document_name = "My_Document_#{SecureRandom.hex(7)}.docx"
      TestingAppServer::SampleFilesLocation.upload_to_tmp_folder(@document_name)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title(@document_name))
      TestingAppServer::SampleFilesLocation.delete_from_tmp_folder(@document_name)
    end

    it '[My Documents] Upload file from Actions menu works' do
      file_path = TestingAppServer::SampleFilesLocation.path_to_tmp_file + @document_name
      @documents_page.actions_upload_file(file_path)
      expect(api_admin.documents).to be_document_exist(@document_name)
    end

    it '[My Documents] Upload file and folder buttons from Actions menu are visible' do
      @documents_page.open_documents_actions
      expect(@documents_page).to be_upload_file_and_folder_button_present
    end
  end
end
