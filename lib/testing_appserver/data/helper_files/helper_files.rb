# frozen_string_literal: true

module TestingAppServer
  # AppServer files helper
  class HelperFiles
    def self.path_to_file
      "#{ENV['HOME']}/RubymineProjects/testing-appserver/lib/testing_appserver/data/helper_files/"
    end

    def self.path_to_tmp_file
      "#{HelperFiles.path_to_file}tmp/"
    end

    def self.file_by_format
      {
        xlsx: 'my_spreadsheet.xlsx',
        docx: 'my_document.docx',
        pptx: 'my_presentation.pptx',
        zip: 'ChromeSetup.zip',
        mp3: 'Track_9.mp3',
        jpg: 'my_picture.jpg'
      }
    end

    def self.upload_to_tmp_folder(file)
      file_extension = file.split('.')[-1].to_sym
      FileUtils.cp(HelperFiles.path_to_file + HelperFiles.file_by_format[file_extension], HelperFiles.path_to_tmp_file + file)
    end

    def self.delete_from_tmp_folder(file)
      FileUtils.rm(HelperFiles.path_to_tmp_file + file)
    end

    def self.files_by_extension(files, extension)
      extension_files = []
      files.each { |file| extension_files << file if file.end_with?(extension.to_s) }
      extension_files
    end
  end
end
