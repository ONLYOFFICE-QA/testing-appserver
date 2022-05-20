# frozen_string_literal: true

module TestingAppServer
  # AppServer Version history pop up
  # https://user-images.githubusercontent.com/40513035/169486982-db58d8cc-8bec-44b3-a024-cfc406316bec.png
  module DocumentsVersionHistory
    include PageObject

    span(:history_edit_comment, xpath: "//span[text()='Edit comment']")
    text_area(:comment_area, xpath: "//div[contains(@class, 'version_edit-comment textarea')]//textarea")
    div(:save_comment, xpath: "//div[contains(@class, 'version_edit-comment-button-primary')]")

    span(:history_download, xpath: "//span[contains(text(), 'Download')]")

    def version_xpath(version)
      "//div[contains(@class, 'version_badge versioned')]/p[contains(text(), '#{version}')]"
    end

    def version_is_present?(version)
      @instance.webdriver.element_visible?(version_xpath(version))
    end

    def version_menu(action, version, params = {})
      open_version_menu(version)
      case action
      when :download
        history_download_element.click
      when :edit_comment
        history_edit_comment_element.click
        @instance.webdriver.wait_until { save_comment_element.present? }
        self.comment_area = params[:comment]
        save_comment_element.click
        @instance.webdriver.wait_until { !save_comment_element.present? }
      end
    end

    def open_version_menu(version)
      menu_xpath = "#{version_xpath(version)}/../../../../../div[contains(@class, 'menu')]" # add_id
      @instance.webdriver.driver.find_element(:xpath, menu_xpath).click
      @instance.webdriver.wait_until { history_edit_comment_element.present? }
    end

    def document_comment(version)
      comment_xpath = "#{version_xpath(version)}/../../..//p[contains(@class, 'version_text')]"
      @instance.webdriver.driver.find_element(:xpath, comment_xpath).text
    end
  end
end
