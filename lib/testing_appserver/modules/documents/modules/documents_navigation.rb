# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents left side bar navigation module
  # https://user-images.githubusercontent.com/40513035/149236384-9e6fbd2f-fb94-4a6a-939c-b79b2c2f5ef8.png
  module DocumentsNavigation
    include PageObject

    list_item(:my_documents_folder, xpath: "//li[contains (@class, 'tree-node-my')]")
    list_item(:shared_with_me_folder, xpath: "//li[contains (@class, 'tree-node-share')]")
    list_item(:favorites_folder, xpath: "//li[contains (@class, 'tree-node-favorites')]")
    list_item(:recent_folder, xpath: "//li[contains (@class, 'tree-node-recent')]")
    list_item(:private_room_folder, xpath: "//li[contains (@class, 'tree-node-privacy')]")
    list_item(:common_folder, xpath: "//li[contains (@class, 'tree-node-common')]")
    list_item(:trash_folder, xpath: "//li[contains (@class, 'tree-node-trash')]")

    def documents_navigation(folder)
      instance_eval("#{folder}_folder_element.click", __FILE__, __LINE__) # choose action from documents menu

      case folder
      when :my_documents
        MyDocuments.new(@instance)
      when :shared_with_me
        DocumentsSharedWithMe.new(@instance)
      when :favorites
        DocumentsFavorites.new(@instance)
      when :recent
        DocumentsRecent.new(@instance)
      when :private_room
        DocumentsPrivateRoom.new(@instance)
      when :common
        DocumentsCommon.new(@instance)
      when :trash
        DocumentsTrash.new(@instance)
      end
    end
  end
end
