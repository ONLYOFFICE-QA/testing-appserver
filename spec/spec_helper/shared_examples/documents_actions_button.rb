# frozen_string_literal: true

require 'tempfile'

shared_examples_for 'documents_actions_button' do |folder, api_admin|
  describe 'Document' do
    before do
      @new_document = TestingAppServer::GeneralData.generate_random_name('New_Document')
      @documents_page.create_file_from_action(:new_document, @new_document)
    end

    after { api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{@new_document}.docx")) }

    it "[#{folder}] Created from Actions menu `New Document` exist in list" do
      expect(api_admin.documents).to be_document_exist("#{@new_document}.docx")
    end

    it "[#{folder}] Created from Actions menu `New Document` opens correctly" do
      skip('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56438') if @test.product == :appserver
      expect(@documents_page.check_opened_file_name).to eq("#{@new_document}.docx")
    end
  end

  describe 'Spreadsheet' do
    before do
      @new_spreadsheet = TestingAppServer::GeneralData.generate_random_name('New_Spreadsheet')
      @documents_page.create_file_from_action(:new_spreadsheet, @new_spreadsheet)
    end

    after { api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{@new_spreadsheet}.xlsx")) }

    it "[#{folder}] Created from Actions menu `New Spreadsheet` exist in list" do
      expect(api_admin.documents).to be_document_exist("#{@new_spreadsheet}.xlsx")
    end

    it "[#{folder}] Created from Actions menu `New Spreadsheet` opens correctly" do
      skip('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56438') if @test.product == :appserver
      expect(@documents_page.check_opened_file_name).to eq("#{@new_spreadsheet}.xlsx")
    end
  end

  describe 'Presentation' do
    before do
      @new_presentation = TestingAppServer::GeneralData.generate_random_name('New_Presentation')
      @documents_page.create_file_from_action(:new_presentation, @new_presentation)
    end

    after { api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{@new_presentation}.pptx")) }

    it "[#{folder}] Created from Actions menu `New Presentation` exist in list" do
      expect(api_admin.documents).to be_document_exist("#{@new_presentation}.pptx")
    end

    it "[#{folder}] Created from Actions menu `New Presentation` opens correctly" do
      skip('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56438') if @test.product == :appserver
      expect(@documents_page.check_opened_file_name).to eq("#{@new_presentation}.pptx")
    end
  end

  describe 'Form Template Blank' do
    before do
      @new_form_blank = TestingAppServer::GeneralData.generate_random_name('New_Form_Blank')
      @documents_page.create_file_from_action(:form_blank, @new_form_blank)
    end

    after { api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{@new_form_blank}.docxf")) }

    it "[#{folder}] Created from Actions menu `Blank Form` template exist in list" do
      expect(api_admin.documents).to be_document_exist("#{@new_form_blank}.docxf")
    end

    it "[#{folder}] Created from Actions menu `Blank Form` template opens correctly" do
      skip('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56438') if @test.product == :appserver
      expect(@documents_page.check_opened_file_name).to eq("#{@new_form_blank}.docxf")
    end
  end

  describe 'Form Template From File' do
    before do
      @new_form_from_file = TestingAppServer::GeneralData.generate_random_name('New_Form_From_File')
      @new_form_document = Tempfile.new(%w[New_Document .docx])
      TestingAppServer::SampleFilesLocation.copy_file_to_temp(@new_form_document)
      api_admin.documents.upload_to_my_document(@new_form_document.path)
      pending('500 (Internal Server Error) for Form Template From File creation') if @test.product == :appserver
      @documents_page.create_file_from_action(:form_from_file, @new_form_from_file, form_template: File.basename(@new_form_document))
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{@new_form_from_file}.docxf"))
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title("#{@new_form_document}.docx"))
    end

    it "[#{folder}] Created from Actions menu `Form Template` From File exist in list" do
      expect(api_admin.documents).to be_document_exist("#{@new_form_from_file}.docxf")
    end

    it "[#{folder}] Created from Actions menu `Form Template` From File opens correctly" do
      skip('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56438') if @test.product == :appserver
      expect(@documents_page.check_opened_file_name).to eq("#{@new_form_from_file}.docxf")
    end
  end

  describe 'Folder' do
    before { @new_folder = TestingAppServer::GeneralData.generate_random_name('New_Folder') }

    after { api_admin.documents.delete_group(folders: api_admin.documents.id_by_folder_title(@new_folder)) }

    it "[#{folder}] Create `New Folder` from Actions menu" do
      @documents_page.create_file_from_action(:new_folder, @new_folder)
      expect(api_admin.documents).to be_folder_exist(@new_folder)
    end
  end

  describe 'File Upload' do
    before do
      # @document_name = "My_Document_#{SecureRandom.hex(7)}.docx"
      @document = Tempfile.new(%w[My_Document .docx])
      TestingAppServer::SampleFilesLocation.copy_file_to_temp(@document)
    end

    after do
      api_admin.documents.delete_group(files: api_admin.documents.id_by_file_title(File.basename(@document)))
    end

    it "[#{folder}] `Upload file` from Actions menu works" do
      @documents_page.actions_upload_file(@document.path)
      expect(api_admin.documents).to be_document_exist(File.basename(@document))
    end

    it "[#{folder}] Upload file and folder buttons from Actions menu are visible" do
      @documents_page.open_documents_actions
      expect(@documents_page).to be_upload_file_and_folder_button_present
    end
  end
end
