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

    def document_in_view_mode?
      @instance.webdriver.choose_tab(2)
      @instance.doc_instance.management.viewer?
    end

    def document_exist?(document_title)
      files_list = all_my_documents_files(filter_type(document_title))
      current_title_exist?(document_title, files_list)
    end

    def common_document_exist?(document_title)
      files_list = all_common_documents_files(filter_type(document_title))
      current_title_exist?(document_title, files_list)
    end

    def folder_exist?(folder_title)
      folder_list = all_my_documents_folders
      current_title_exist?(folder_title, folder_list)
    end

    def common_folder_exist?(folder_title)
      folder_list = all_common_documents_folders
      current_title_exist?(folder_title, folder_list)
    end

    def id_by_file_title(document_title, folder_type = :my_documents)
      case folder_type
      when :my_documents
        files_list = all_my_documents_files(filter_type(document_title))
      when :common
        files_list = all_common_documents_files(filter_type(document_title))
      end
      document_id_from_file_list(document_title, files_list)
    end

    def common_id_by_title(document_title)
      files_list = all_common_documents_files(filter_type(document_title))
      document_id_from_file_list(document_title, files_list)
    end

    def document_id_from_file_list(document_title, files_list)
      files_list.each { |file| return file['id'] if document_title == file['title'] }
    end

    def delete_files_by_title(documents_title_list, folder_type = :my_documents)
      documents_title_list.each { |document_title| delete_group(files: id_by_file_title(document_title, folder_type)) }
    end

    def id_by_folder_title(folder_name, folder_type = :my_documents)
      case folder_type
      when :my_documents
        folder_list = all_my_documents_folders
      when :common
        folder_list = all_common_documents_folders
      end
      document_id_from_file_list(folder_name, folder_list)
    end

    def common_id_by_folder_title(folder_name)
      folder_list = all_common_documents_folders
      document_id_from_file_list(folder_name, folder_list)
    end

    def delete_folders_by_title(folders_title_list, folder_type = :my_documents)
      folders_title_list.each { |folder_title| delete_group(folders: id_by_folder_title(folder_title, folder_type)) }
    end

    def create_folder_by_folder_type(name, folder_type = :my_documents)
      case folder_type
      when :my_documents
        id = my_documents_folder['current']['id']
      when :common
        id = common_documents_folder['current']['id']
      end
      Teamlab.files.new_folder(id, name).body['response']
    end

    def get_id_provider_folder_by_name(folder_name, folder_type)
      case folder_type
      when :my_documents
        all_folders = my_documents_folder['folders']
      when :common
        all_folders = common_documents_folder['folders']
      end
      all_folders.each { |folder| return folder['id'] if folder['title'].to_s == folder_name }
      nil
    end

    def upload_to_folder(folder_name, file_path, folder_type = :my_documents)
      id_folder = get_id_provider_folder_by_name(folder_name, folder_type)
      upload_file_to_folder(id_folder, file_path)
    end

    def file_by_extension(files_array, extension)
      files_array.each { |file| return file if File.extname(file).include?(extension.to_s) }
    end

    # @param link [String] Link to the file
    # @return [String] File title
    def external_link_file_title(link)
      @test = PersonalTestInstance.new
      @test.webdriver.open(link)
      @test.init_online_documents
      @test.doc_instance.management.wait_for_operation_with_round_status_canvas
      @test.doc_instance.doc_editor.top_toolbar.title_row.document_name
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
