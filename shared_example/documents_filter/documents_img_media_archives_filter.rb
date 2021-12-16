# frozen_string_literal: true

shared_examples_for 'documents_img_media_archives_filter' do |folder|
  it "Images filter works in #{folder}" do
    documents_page.set_filter(:images)
    expect(documents_page).to be_file_present(TestingAppServer::HelperFiles::JPG)
    expect(documents_page).not_to be_files_present(@files_array - [TestingAppServer::HelperFiles::JPG])
    expect(documents_page).not_to be_file_present(@folder_name)
  end

  it "Media filter works in #{folder}" do
    documents_page.set_filter(:media)
    expect(documents_page).to be_file_present(TestingAppServer::HelperFiles::MP3)
    expect(documents_page).not_to be_files_present(@files_array - [TestingAppServer::HelperFiles::MP3])
    expect(documents_page).not_to be_file_present(@folder_name)
  end

  it "Archives filter works in #{folder}" do
    documents_page.set_filter(:archives)
    expect(documents_page).to be_file_present(TestingAppServer::HelperFiles::ZIP)
    expect(documents_page).not_to be_files_present(@files_array - [TestingAppServer::HelperFiles::ZIP])
    expect(documents_page).not_to be_file_present(@folder_name)
  end
end
