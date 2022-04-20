# frozen_string_literal: true

shared_examples_for 'documents_users_groups_filter' do |product, folder, files_array, folder_name, admin, user,
  admin_group, user_group|
  it "[#{product}][#{folder}] `Group` filter works" do
    pending('Groups filter doesnt work: https://bugzilla.onlyoffice.com/show_bug.cgi?id=54567')
    documents_page.set_filter(:groups, group_name: admin_group['name'])
    expect(documents_page).to be_files_present(files_array)
    expect(documents_page).to be_file_present(folder_name)
    documents_page.set_filter(:groups, group_name: user_group['name'])
    expect(documents_page).to be_nothing_found
  end

  it "[#{product}][#{folder}] `User` filter works" do
    documents_page.set_filter(:users, user_name: admin.full_name)
    expect(documents_page).to be_files_present(files_array)
    expect(documents_page).to be_file_present(folder_name)
    documents_page.set_filter(:users, user_name: user.full_name)
    expect(documents_page).to be_nothing_found
  end
end
