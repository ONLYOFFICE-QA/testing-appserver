# frozen_string_literal: true

require_relative '../../../helper/download_helper'
require_relative '../../../top_toolbar/top_toolbar'
require_relative 'document_creation_field'
require_relative 'pop_up_windows/documents_form_template_from_file'
require_relative 'documents_filter'
require_relative 'documents_helper'
require_relative 'documents_actions'
require_relative 'documents_group_actions'
require_relative 'documents_list_item'
require_relative 'documents_navigation'
require_relative 'documents_select_all_filter'

module TestingAppServer
  # All documents required
  module DocumentsModules
    include AppServerDownloadHelper
    include DocumentsCreationField
    include DocumentsFormTemplateFromFile
    include DocumentsFilter
    include DocumentsHelper
    include DocumentsActions
    include DocumentsGroupActions
    include DocumentsListItem
    include DocumentsNavigation
    include DocumentsSelectAllFilter
    include TopToolbar

    def create_file_from_action(document_type, title, form_template: nil)
      actions_documents(document_type)
      choose_file_for_form_template(form_template) if document_type == :form_from_file
      add_name_to_file(title)
      @instance.webdriver.switch_to_main_tab
      @instance.webdriver.wait_until(PageObject.default_page_wait, "File with name #{title} is not in the list") do
        file_present?(file_full_title(document_type, title))
      end
    end

    def file_full_title(document_type, title)
      case document_type
      when :new_document
        "#{title}.docx"
      when :new_spreadsheet
        "#{title}.xlsx"
      when :new_presentation
        "#{title}.pptx"
      when :form_blank, :form_from_file
        "#{title}.docxf"
      when :new_folder
        title
      end
    end
  end
end
