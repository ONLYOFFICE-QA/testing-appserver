# frozen_string_literal: true

require_relative '../../../helper/api/documents_api'

module TestingAppServer
  # AppServer Documents module Helper methods
  module DocumentsHelper
    def check_opened_file_name
      @instance.webdriver.choose_tab(2)
      @instance.init_online_documents
      @instance.doc_instance.management.wait_for_operation_with_round_status_canvas
      @instance.doc_instance.doc_editor.top_toolbar.title_row.document_name
    end

    def document_exist?(document_title)
      files_list = all_my_documents_files(filter_type(document_title))
      current_title_exist?(document_title, files_list)
    end

    def folder_exist?(folder_title)
      folder_list = all_my_documents_folders
      current_title_exist?(folder_title, folder_list)
    end

    def id_by_file_title(document_title)
      files_list = all_my_documents_files(filter_type(document_title))
      files_list.each { |file| return file['id'] if document_title == file['title'] }
    end

    def delete_files_by_title(documents_title_list)
      documents_title_list.each { |document_title| delete_group(files: id_by_file_title(document_title)) }
    end

    def id_by_folder_title(folder_name)
      folder_list = all_my_documents_folders
      folder_list.each { |folder| return folder['id'] if folder_name == folder['title'] }
    end

    def delete_folders_by_title(folders_title_list)
      folders_title_list.each { |folder_title| delete_group(folders: id_by_folder_title(folder_title)) }
    end

    def create_folder_in_my_documents(name)
      id = my_documents_folder['current']['id']
      Teamlab.files.new_folder(id, name).body['response']
    end

    def get_id_provider_folder_by_name(folder_name)
      my_documents_folder['folders'].each { |folder| return folder['id'] if folder['title'].to_s == folder_name }
      nil
    end

    def upload_to_folder(folder_name, file_path)
      id_folder = get_id_provider_folder_by_name(folder_name)
      upload_file_to_folder(id_folder, file_path)
    end

    private

    def current_title_exist?(title, item_list)
      return false if item_list.empty?

      item_list.each do |item|
        return true if title == item['title']
      end
      false
    end

    def filter_type(file_name)
      if file_name.end_with?('.docx')
        'DocumentsOnly'
      elsif file_name.end_with?('.xlsx')
        'SpreadsheetsOnly'
      elsif file_name.end_with?('.pptx')
        'PresentationsOnly'
      else
        'None'
      end
    end
  end
end