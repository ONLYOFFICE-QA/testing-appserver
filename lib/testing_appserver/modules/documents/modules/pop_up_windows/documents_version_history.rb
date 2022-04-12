# frozen_string_literal: true

module TestingAppServer
  # AppServer Version history pop up
  # https://user-images.githubusercontent.com/40513035/162714618-34438dd2-b8a9-4eed-bc94-ccf83c32d375.png
  module DocumentsVersionHistory
    def version_xpath(version)
      "//div[contains(@class, 'version_badge versioned')]/p[contains(text(), '#{version}')]"
    end

    def version_is_present?(version)
      @instance.webdriver.element_visible?(version_xpath(version))
    end

    def download_version(version)
      download_xpath = "#{version_xpath(version)}/../../..//a[text() = 'Download']" # add_id
      @instance.webdriver.driver.find_element(:xpath, download_xpath).click
    end
  end
end
