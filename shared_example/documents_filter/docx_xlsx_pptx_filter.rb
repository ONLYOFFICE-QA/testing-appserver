# frozen_string_literal: true

shared_examples_for 'docx_xlsx_pptx_filter' do |product, folder, files_array, folder_name|
  it "[#{product}][#{folder}] `Documents` filter works" do
    documents_page.set_filter(:documents)
    docs_files = TestingAppServer::SampleFilesLocation.files_by_extension(files_array, :docx)
    expect(documents_page).to be_files_present(docs_files)
    expect(documents_page).not_to be_files_present(files_array - docs_files)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "[#{product}][#{folder}] `Presentations` filter works" do
    documents_page.set_filter(:presentations)
    pptx_files = TestingAppServer::SampleFilesLocation.files_by_extension(files_array, :pptx)
    expect(documents_page).to be_files_present(pptx_files)
    expect(documents_page).not_to be_files_present(files_array - pptx_files)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "[#{product}][#{folder}] `Spreadsheets` filter works" do
    documents_page.set_filter(:spreadsheets)
    xlsx_files = TestingAppServer::SampleFilesLocation.files_by_extension(files_array, :xlsx)
    expect(documents_page).to be_files_present(xlsx_files)
    expect(documents_page).not_to be_files_present(files_array - xlsx_files)
    expect(documents_page).not_to be_file_present(folder_name)
  end
end
