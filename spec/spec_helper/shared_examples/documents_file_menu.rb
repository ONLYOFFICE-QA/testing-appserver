# frozen_string_literal: true

shared_examples_for 'documents_file_menu' do |folder, api_admin, new_document, version_document, move_document,
  copy_document, create_copy_document, rename_document, delete_document, folder_name|
  describe 'File menu' do
    it "[#{folder}][File Menu] `Edit` file opens correct file" do
      skip('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56438') if @test.product == :appserver
      expect(documents_page.file_settings(new_document, :edit)).to eq(new_document)
    end

    it "[#{folder}][File Menu] `Share external link` works" do
      skip('Console error GET https://personal.teamlab.info/api/2.0/people/@self.json 401 when open external link')
      documents_page.file_settings(new_document, :sharing_settings)
      external_link = documents_page.copy_external_link
      expect(documents_page.external_link_file_title(external_link)).to eq(new_document)
    end

    describe 'Version' do
      it "[#{folder}][File Menu] Finalize version appears lock" do
        documents_page.file_settings(new_document, :finalize_version)
        expect(documents_page.file_version(new_document)).to eq(2)
      end

      it "[#{folder}][File Menu] New version appears in version history" do
        documents_page.file_settings(version_document, :finalize_version)
        documents_page.file_settings(version_document, :version_history)
        expect(documents_page).to be_version_is_present(2)
      end

      it "[#{folder}][File Menu] Download first version" do
        documents_page.file_settings(version_document, :version_history)
        documents_page.download_version(1)
        expect(documents_page).to be_file_downloaded(version_document)
      end
    end

    it "[#{folder}][File Menu] Download button works" do
      documents_page.file_settings(new_document, :download)
      expect(documents_page).to be_file_downloaded(new_document)
    end

    describe 'Move or copy' do
      it "[#{folder}][File Menu] Move to button works" do
        documents_page.file_settings(move_document, :move_to, move_to_folder: folder_name)
        expect(documents_page).not_to be_file_present(move_document)
        documents_page.open_folder(folder_name)
        expect(documents_page).to be_file_present(move_document)
      end

      it "[#{folder}][File Menu] Copy to button work" do
        documents_page.file_settings(copy_document, :copy, copy_folder: folder_name)
        expect(documents_page).to be_file_present(copy_document)
        documents_page.open_folder(folder_name)
        expect(documents_page).to be_file_present(copy_document)
      end

      it "[#{folder}][File Menu] Create a copy button work" do
        expect(documents_page.file_copies_count(create_copy_document)).to eq(1)
        documents_page.file_settings(create_copy_document, :create_copy)
        expect(documents_page.file_copies_count(create_copy_document)).to eq(2)
      end
    end

    it "[#{folder}][File Menu] Rename button works" do
      renamed_file = TestingAppServer::GeneralData.generate_random_name('New_Document')
      documents_page.file_settings(rename_document, :rename, rename_file: renamed_file)
      expect(api_admin.documents).to be_document_exist("#{renamed_file}.docx")
    end

    it "[#{folder}][File Menu] Delete button works" do
      documents_page.file_settings(delete_document, :delete)
      expect(documents_page).not_to be_file_present(delete_document)
    end
  end
end
