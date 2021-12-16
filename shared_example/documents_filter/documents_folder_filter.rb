# frozen_string_literal: true

shared_examples_for 'documents_folder_filter' do |folder|
  it "Folder filter works in #{folder}" do
    documents_page.set_filter(:folders)
    expect(documents_page).to be_file_present(@folder_name)
    expect(documents_page).not_to be_files_present(@files_array)
  end

  it "Media filter works in #{folder}" do
    documents_page.set_filter(:all_files)
    expect(documents_page).to be_files_present(@files_array)
    expect(documents_page).not_to be_file_present(@folder_name)
  end

  it "No subfolders filter works in #{folder}" do
    @my_documents_page.fill_filter('docx')
    expect(@my_documents_page).to be_file_present(TestingAppServer::HelperFiles::DOCX)
    expect(@my_documents_page).to be_file_present(TestingAppServer::HelperFiles::DOCX_1)
    @my_documents_page.set_filter(:no_subfolders)
    expect(@my_documents_page).to be_file_present(TestingAppServer::HelperFiles::DOCX)
    expect(@my_documents_page).not_to be_file_present(TestingAppServer::HelperFiles::DOCX_1)
  end
end
