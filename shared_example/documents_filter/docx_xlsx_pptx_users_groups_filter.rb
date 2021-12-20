# frozen_string_literal: true

shared_examples_for 'docx_xlsx_pptx_users_groups_filter' do |folder, files_array, folder_name, admin, user,
  admin_group, user_group|
  it "Documents filter works in #{folder}" do
    documents_page.set_filter(:documents)
    docs_files = TestingAppServer::HelperFiles.files_by_extension(files_array, :docx)
    expect(documents_page).to be_files_present(docs_files)
    expect(documents_page).not_to be_files_present(files_array - docs_files)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "Presentations filter works in #{folder}" do
    documents_page.set_filter(:presentations)
    pptx_files = TestingAppServer::HelperFiles.files_by_extension(files_array, :pptx)
    expect(documents_page).to be_files_present(pptx_files)
    expect(documents_page).not_to be_files_present(files_array - pptx_files)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "Spreadsheets filter works in #{folder}" do
    documents_page.set_filter(:spreadsheets)
    xlsx_files = TestingAppServer::HelperFiles.files_by_extension(files_array, :xlsx)
    expect(documents_page).to be_files_present(xlsx_files)
    expect(documents_page).not_to be_files_present(files_array - xlsx_files)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "Group filter works in #{folder}" do
    pending('Groups filter doesnt work: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54567')
    documents_page.set_filter(:groups, group_name: admin_group['name'])
    expect(documents_page).to be_files_present(files_array)
    expect(documents_page).to be_file_present(folder_name)
    documents_page.set_filter(:groups, group_name: user_group['name'])
    expect(documents_page).to be_nothing_found
  end

  it "User filter works in #{folder}" do
    pending('User search doesnt work with both name and surname: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54568')
    documents_page.set_filter(:users, user_name: admin.full_name)
    expect(documents_page).to be_files_present(files_array)
    expect(documents_page).to be_file_present(folder_name)
    documents_page.set_filter(:users, user_name: user.full_name)
    expect(documents_page).to be_nothing_found
  end
end
