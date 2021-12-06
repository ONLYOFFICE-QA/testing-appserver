# frozen_string_literal: true

require_relative '../../modules/documents/modules/documents_helper'

module TestingAppServer
  # Api helper methods for Documents module
  class DocumentsApi
    include DocumentsHelper

    # @param filter_type [String] None, DocumentsOnly, PresentationsOnly, SpreadsheetsOnly, ImagesOnly, ArchiveOnly, MediaOnly
    # @return [Array] List of all my documents specified in request
    def get_all_my_files(filter_type)
      Teamlab.files.get_my_docs(filterType: filter_type).body['response']['files']
    end

    # @return [Array] List of all folders from My documents specified in request
    def all_my_documents_folders
      Teamlab.files.get_my_docs(filterType: 'FoldersOnly').body['response']['folders']
    end

    # @param files [Array] Files IDs for deleting
    # @param folders [Array] Folder IDs for deleting
    # @return [Hash] Operation result and deleted folder information
    def delete_group(files: [], folders: [])
      Teamlab.files.delete(fileIds: files, folderIds: folders)
    end
  end
end
