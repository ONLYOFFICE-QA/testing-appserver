# frozen_string_literal: true

module TestingAppServer
  # Appserver empty Trash pop up
  # https://user-images.githubusercontent.com/38238032/180782386-b20b4d63-516a-4dc4-8fe9-b903feebd516.jpg
  module DocumentsEmptyTrashWindow
    include PageObject
    svg_xpath = "/*[name() = 'svg' and contains(@data-src, 'images/clear.trash.react.svg')]"

    svg(:header_trash_icon, xpath: "//div[contains(@class, 'icon-button_svg not-selectable')]#{svg_xpath}")
    svg(:sidebar_trash_icon, xpath: "//div[contains(@class, 'catalog-icon__badge')]#{svg_xpath}")
    svg(:close_icon,
        xpath: "//div[contains(@class, 'modal-dialog-content')]//*[name() = 'svg' and contains(@class, 'modal-dialog-button_close')]")

    button(:delete_button, xpath: "//div[contains(@class, 'modal-dialog-modal-footer')]/button[1]")
    button(:cancel_button, xpath: "//div[contains(@class, 'modal-dialog-modal-footer')]/button[2]")

    def empty_trash_header_button_clicked
      header_trash_icon_element.click
      delete_button
      wait_trash_operations_completed
    end

    def empty_trash_sidebar_button_clicked
      sidebar_trash_icon_element.click
      delete_button
      wait_trash_operations_completed
    end

    def empty_trash_cancel_button_clicked
      header_trash_icon_element.click
      cancel_button
    end

    def empty_trash_close_icon_clicked
      header_trash_icon_element.click
      close_icon_element.click
    end

  end
end
