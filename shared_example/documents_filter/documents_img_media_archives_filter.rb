# frozen_string_literal: true

shared_examples_for 'documents_img_media_archives_filter' do |folder, files_array, folder_name|
  it "Images filter works in #{folder}" do
    documents_page.set_filter(:images)
    images = TestingAppServer::SampleFilesLocation.files_by_extension(files_array, :jpg)
    expect(documents_page).to be_files_present(images)
    expect(documents_page).not_to be_files_present(files_array - images)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "Media filter works in #{folder}" do
    documents_page.set_filter(:media)
    audios = TestingAppServer::SampleFilesLocation.files_by_extension(files_array, :mp3)
    expect(documents_page).to be_files_present(audios)
    expect(documents_page).not_to be_files_present(files_array - audios)
    expect(documents_page).not_to be_file_present(folder_name)
  end

  it "Archives filter works in #{folder}" do
    documents_page.set_filter(:archives)
    archives = TestingAppServer::SampleFilesLocation.files_by_extension(files_array, :zip)
    expect(documents_page).to be_files_present(archives)
    expect(documents_page).not_to be_files_present(files_array - archives)
    expect(documents_page).not_to be_file_present(folder_name)
  end
end
