# frozen_string_literal: true

module TestingAppServer
  # AppServer Documents filter
  # https://user-images.githubusercontent.com/40513035/174546418-10b55013-5abf-42f1-83cd-5e83588ac554.png
  module DocumentsSearchField
    include PageObject

    text_field(:search_field, xpath: "//input[contains(@class,'search-input-block')]")

    def search_file(document_name)
      search_field_element.send_keys(document_name)
    end

    def not_found?
      @instance.webdriver.wait_until { not_found_visible? }
    end

    def not_found_visible?
      not_found_xpath = "//div[contains(@class, 'section-scroll scroll-body')]//span[text() = 'Nothing found']"
      @instance.webdriver.element_visible?(not_found_xpath)
    end
  end
end
