# frozen_string_literal: true

shared_examples_for 'documents_select_all_checkbox' do |folder, all_files_and_folders, document_name,
  spreadsheet_name, presentation_name, audio_name, archive_name, picture_name, folder_name|
  before { documents_page.check_file_checkbox(document_name) }

  it "[#{folder}] `Select all Documents` works" do
    documents_page.select_files_filter(:documents)
    expect(documents_page).to be_file_checkbox_present(document_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [document_name])
  end

  it "[#{folder}] `Select all Media` works" do
    pending('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56391')
    documents_page.select_files_filter(:media)
    expect(documents_page).to be_file_checkbox_present(audio_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [audio_name])
  end

  it "[#{folder}] `Select all Presentations` works" do
    documents_page.select_files_filter(:presentations)
    expect(documents_page).to be_file_checkbox_present(presentation_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [presentation_name])
  end

  it "[#{folder}] `Select all Spreadsheets` works" do
    documents_page.select_files_filter(:spreadsheets)
    expect(documents_page).to be_file_checkbox_present(spreadsheet_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [spreadsheet_name])
  end

  it "[#{folder}] `Select all Files` works" do
    documents_page.select_files_filter(:all_files)
    expect(documents_page).to be_files_checked(all_files_and_folders - [folder_name])
    expect(documents_page).to be_all_files_not_checked([folder_name])
  end

  it "[#{folder}] `Select all Images` works" do
    documents_page.select_files_filter(:images)
    expect(documents_page).to be_file_checkbox_present(picture_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [picture_name])
  end

  it "[#{folder}] `Select all Archives` works" do
    documents_page.select_files_filter(:archives)
    expect(documents_page).to be_file_checkbox_present(archive_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [archive_name])
  end

  it "[#{folder}] `Select all Folders` works" do
    documents_page.select_files_filter(:folders)
    expect(documents_page).to be_file_checkbox_present(folder_name)
    expect(documents_page).to be_all_files_not_checked(all_files_and_folders - [folder_name])
  end

  it "[#{folder}] `Select all All` works" do
    documents_page.select_files_filter(:all)
    expect(documents_page).to be_files_checked(all_files_and_folders)
  end
end
