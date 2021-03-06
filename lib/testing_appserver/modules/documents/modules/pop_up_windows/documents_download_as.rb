# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents Download as pop up
  # https://user-images.githubusercontent.com/40513035/160786508-473de85e-793b-481e-b05a-41abe80b5156.png
  module DocumentsDownloadAs
    include PageObject

    span(:chose_format, xpath: "//h1[text()='Download as']/../..//span[contains(@class, 'text')]") # add_id
    button(:download_save, xpath: "//div[contains(@class, 'modal-dialog-aside-footer')]//button[1]")

    def format_dropdown(format)
      "(//div[@data-key='#{format}'])[1]"
    end

    def open_dropdown_formats
      chose_format_element.click
      @instance.webdriver.wait_until { @instance.webdriver.element_visible?(format_dropdown('original')) }
    end

    def choose_format_to_convert(format)
      open_dropdown_formats
      @instance.webdriver.driver.find_element(:xpath, format_dropdown(format)).click
      download_save_element.click
      @instance.webdriver.wait_until { !chose_format_element.present? }
    end

    def converted_file(file_title, file_format, format_to_convert)
      format_to_convert = ".#{file_format}" if format_to_convert == 'original'
      file_without_extension = File.basename(file_title, '.*')
      "#{file_without_extension}#{format_to_convert}"
    end
  end
end
