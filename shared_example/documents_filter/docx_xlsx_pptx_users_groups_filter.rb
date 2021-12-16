# frozen_string_literal: true

shared_examples_for 'docx_xlsx_pptx_users_groups_filter' do |folder, admin, user|
  it "Documents filter works in #{folder}" do
    documents_page.set_filter(:documents)
    docs_files = [TestingAppServer::HelperFiles::DOCX, TestingAppServer::HelperFiles::DOCX_1]
    expect(documents_page).to be_files_present(docs_files)
    expect(documents_page).not_to be_files_present(@files_array - docs_files)
    expect(documents_page).not_to be_file_present(@folder_name)
  end

  it "Presentations filter works in #{folder}" do
    documents_page.set_filter(:presentations)
    expect(documents_page).to be_file_present(TestingAppServer::HelperFiles::PPTX)
    expect(documents_page).not_to be_files_present(@files_array - [TestingAppServer::HelperFiles::PPTX])
    expect(documents_page).not_to be_file_present(@folder_name)
  end

  it "Spreadsheets filter works in #{folder}" do
    documents_page.set_filter(:spreadsheets)
    expect(documents_page).to be_file_present(TestingAppServer::HelperFiles::XLSX)
    expect(documents_page).not_to be_files_present(@files_array - [TestingAppServer::HelperFiles::XLSX])
    expect(documents_page).not_to be_file_present(@folder_name)
  end

  it "Group filter works in #{folder}" do
    pending('Groups filter doesnt work: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54567')
    documents_page.set_filter(:groups, group_name: @admin_group['name'])
    expect(documents_page).to be_files_present(@files_array)
    expect(documents_page).to be_file_present(@folder_name)
    documents_page.set_filter(:groups, group_name: @user_group['name'])
    expect(documents_page).to be_nothing_found
  end

  it "User filter works in #{folder}" do
    pending('User search doesnt work with both name and surname: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54568')
    documents_page.set_filter(:users, user_name: admin.full_name)
    expect(documents_page).to be_files_present(@files_array)
    expect(documents_page).to be_file_present(@folder_name)
    documents_page.set_filter(:users, user_name: user.full_name)
    expect(documents_page).to be_nothing_found
  end
end
