# frozen_string_literal: true

shared_examples_for 'documents_folder_filter' do |folder, files_array, folder_name, document_name, document_name_folder|
  it "[#{folder}] `Folder` filter works" do
    documents_page.set_filter(:folders)
    expect(documents_page).to be_file_present(folder_name)
    expect(documents_page).not_to be_files_present(files_array)
  end

  it "[#{folder}] `All Files` filter works" do
    documents_page.set_filter(:all_files)
    expect(documents_page).to be_files_present(files_array)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "[#{folder}] `No subfolders` filter works" do
    documents_page.fill_filter('docx')
    expect(documents_page).to be_file_present(document_name)
    expect(documents_page).to be_file_present(document_name_folder)
    documents_page.set_filter(:no_subfolders)
    expect(documents_page).to be_file_present(document_name)
    expect(documents_page).not_to be_file_present(document_name_folder)
  end
end
