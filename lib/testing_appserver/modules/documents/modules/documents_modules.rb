# frozen_string_literal: true

require_relative 'document_creation_field'
require_relative 'documents_filter'
require_relative 'documents_helper'
require_relative 'documents_actions'
require_relative 'documents_list_item'
require_relative 'documents_navigation'

module TestingAppServer
  # All documents required
  module DocumentsModules
    include DocumentsCreationField
    include DocumentsFilter
    include DocumentsHelper
    include DocumentsActions
    include DocumentsListItem
    include DocumentsNavigation

    def create_file_from_action(document_type, title)
      actions_documents(document_type)
      add_name_to_file(title)
    end
  end
end