# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

describe 'Trash folder for Personal' do
  before do
    @document = Tempfile.new(%w[My_Document .docx])
    @document_name = File.basename(@document)
    TestingAppServer::SampleFilesLocation.copy_file_to_temp(@document)
    api_admin.documents.upload_to_my_document(@document.path)
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @my_documents = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
    @my_documents.file_settings(@document_name, :delete)
    @trash = @my_documents.documents_navigation(:trash)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe '`Restore` option works' do
    before do
      @second_document_name = TestingAppServer::GeneralData.generate_random_name('My_Document')
      @documents = @my_documents.documents_navigation(:my_documents)
      @documents.create_file_from_action(:new_document, @second_document_name)
      @my_documents.file_settings(@second_document_name, :delete)
      @trash = @my_documents.documents_navigation(:trash)
    end

    after do
      @my_documents.file_settings(@document_name, :delete)
      api_admin.documents.delete_files_by_title([@second_document_name])
    end

    it 'Restores both files' do
      @trash.check_file_checkbox(@document_name)
      @trash.check_file_checkbox(@second_document_name)
      @trash.restore_from_trash
      expect(@trash).not_to be_files_present([@document_name, "#{@second_document_name}.docx"])
      @documents = @my_documents.documents_navigation(:my_documents)
      expect(@documents).to be_files_present([@document_name, "#{@second_document_name}.docx"])
    end

    it 'Only selected file is restored' do
      @trash.check_file_checkbox(@document_name)
      @trash.restore_from_trash
      expect(@trash).not_to be_file_present(@document_name)
      expect(@trash).to be_file_present("#{@second_document_name}.docx")
      @documents = @my_documents.documents_navigation(:my_documents)
      expect(@documents).to be_file_present(@document_name)
    end
  end

  it '`Empty trash` header button works' do
    @trash.empty_trash_header_button_clicked
    expect(@trash).to be_trash_empty
  end

  it '`Empty trash` sidebar button works' do
    @trash.empty_trash_sidebar_button_clicked
    expect(@trash).to be_trash_empty
  end

  it '`Cancel` button closes pop up window' do
    @trash.empty_trash_cancel_button_clicked
    expect(@trash).to be_file_present(@document_name)
  end

  it '`Close` icon closes pop up window' do
    @trash.empty_trash_close_icon_clicked
    expect(@trash).to be_file_present(@document_name)
  end
end
