# frozen_string_literal: true

module TestingAppServer
  # Helper methods for checking file downloading
  module AppServerDownloadHelper
    def file_downloaded?(file_name)
      path_to_downloaded_file = "#{@instance.webdriver.download_directory}/#{file_name}"
      OnlyofficeFileHelper::FileHelper.wait_file_to_download(path_to_downloaded_file)
      downloaded_file_size = File.size(path_to_downloaded_file)
      downloaded_file_size > if File.extname(file_name) == '.txt'
                               4
                             else
                               100
                             end
    end
  end
end
