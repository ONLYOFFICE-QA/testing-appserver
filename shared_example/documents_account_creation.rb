# frozen_string_literal: true

shared_examples_for 'documents_account_creation' do |product, type, folder_title, folder_content|
  it "[#{product}] Check #{type} account is added to Connected Clouds Page" do
    case product
    when 'AppServer'
      connected_clouds_page = my_documents_page.documents_navigation(:connected_clouds)
    when 'Personal'
      connected_clouds_page = my_documents_page.open_connected_clouds_for_personal
    end
    expect(connected_clouds_page).to be_account_is_present(folder_title)
  end

  it "[#{product}] Check #{type} account is added to My Documents" do
    expect(my_documents_page).to be_file_present(folder_title)
  end

  it "[#{product}] Check #{type} account contain all files and folders" do
    @my_documents_page.open_folder(folder_title)
    expect(my_documents_page).to be_files_present(folder_content)
  end
end
