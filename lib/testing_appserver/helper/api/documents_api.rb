# frozen_string_literal: true

require_relative '../../modules/documents/modules/documents_helper'

module TestingAppServer
  # Api helper methods for Documents module
  class DocumentsApi
    include DocumentsHelper

    # @param file [String] File name
    # @return [Hash] Inserted to "My documents" section file info
    def upload_to_my_document(file)
      Teamlab.files.upload_to_my_docs(file).body['response']
    end

    # @param id [String] Parent folder ID
    # @param name [String] Folder title
    # @return [Hash] New folder contents
    def create_folder(name, id)
      Teamlab.files.new_folder(id, name).body['response']
    end

    # @param id_folder [String] Folder ID
    # @param file [String] File name
    # @return [Hash] Uploaded file info
    def upload_file_to_folder(id_folder, file)
      Teamlab.files.upload_to_folder(id_folder, file).body['response']
    end

    # @return [Hash] My documents section contents
    def my_documents_folder
      Teamlab.files.get_my_docs.body['response']
    end

    # @param filter_type [String] None, DocumentsOnly, PresentationsOnly, SpreadsheetsOnly, ImagesOnly, ArchiveOnly, MediaOnly
    # @return [Array] List of all my documents specified in request
    def all_my_documents_files(filter_type)
      Teamlab.files.get_my_docs(filterType: filter_type).body['response']['files']
    end

    # @param filter_type [String] None, DocumentsOnly, PresentationsOnly, SpreadsheetsOnly, ImagesOnly, ArchiveOnly, MediaOnly
    # @return [Array] List of all my documents specified in request
    def all_common_documents_files(filter_type)
      Teamlab.files.get_common_docs(filterType: filter_type).body['response']['files']
    end

    # @return [Array] List of all folders from My documents specified in request
    def all_my_documents_folders
      Teamlab.files.get_my_docs(filterType: 'FoldersOnly').body['response']['folders']
    end

    # @return [Array] List of all folders from My documents specified in request
    def all_common_documents_folders
      Teamlab.files.get_common_docs(filterType: 'FoldersOnly').body['response']['folders']
    end

    # @param files [Array] Files IDs for deleting
    # @param folders [Array] Folder IDs for deleting
    # @return [Hash] Operation result and deleted folder information
    def delete_group(files: [], folders: [])
      Teamlab.files.delete(fileIds: files, folderIds: folders)
    end
  end
end
