# frozen_string_literal: true

shared_examples_for 'documents_group_actions' do |product, document_name, move_document, delete_document, folder_name|
  it "[#{product}][My Documents] `Download` group button works" do
    documents_page.check_file_checkbox(document_name)
    documents_page.group_menu_download_file
    expect(documents_page).to be_file_downloaded(document_name)
  end

  it "[#{product}][My Documents] `Download as` group button works" do
    pending('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56394') if product == 'AppServer'
    documents_page.check_file_checkbox(document_name)
    documents_page.group_menu_download_as('.pdf')
    expect(documents_page).to be_file_downloaded("#{File.basename(document_name, '.*')}.pdf")
  end

  it "[#{product}][My Documents] `Move to` Common group button works" do
    documents_page.check_file_checkbox(move_document)
    documents_page.group_menu_move_to(folder_name)
    expect(documents_page).not_to be_file_present(move_document)
    documents_page.open_folder(folder_name)
    expect(documents_page).to be_file_present(move_document)
  end

  it "[#{product}][My Documents] `Copy` to folder group button works" do
    documents_page.check_file_checkbox(document_name)
    documents_page.group_menu_copy_to(folder_name)
    expect(documents_page).to be_file_present(document_name)
    documents_page.open_folder(folder_name)
    expect(documents_page).to be_file_present(document_name)
  end

  it "[#{product}][My Documents] `Delete` group button works" do
    documents_page.check_file_checkbox(delete_document)
    documents_page.group_menu_delete
    expect(documents_page).not_to be_file_present(delete_document)
  end
end
