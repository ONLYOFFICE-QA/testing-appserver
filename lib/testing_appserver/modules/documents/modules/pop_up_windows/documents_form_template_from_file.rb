# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents Form Template from file pop up
  # https://user-images.githubusercontent.com/40513035/158753908-cc956c79-c74b-4677-82e5-4820d527b05e.png
  module DocumentsFormTemplateFromFile
    include PageObject

    button(:save_file_template, xpath: "//button[contains(@class, 'select-file-modal-dialog-buttons-save')]")

    def file_template(file_name)
      "(//div[@class='files-list_full-name']/p[text()='#{file_name}'])[1]"
    end

    def choose_file_for_form_template(file_name)
      @instance.webdriver.wait_until { @instance.webdriver.element_visible?(file_template(file_name)) }
      @instance.webdriver.driver.find_element(:xpath, file_template(file_name)).click
      save_file_template_element.click
    end
  end
end
