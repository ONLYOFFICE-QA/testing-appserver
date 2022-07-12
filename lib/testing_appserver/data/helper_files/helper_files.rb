# frozen_string_literal: true

module TestingAppServer
  # AppServer files helper
  class SampleFilesLocation
    def self.path_to_file
      "#{Dir.pwd}/lib/testing_appserver/data/helper_files/"
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

    def self.copy_file_to_temp(file)
      file_extension = File.extname(file)[1..].to_sym
      FileUtils.cp(SampleFilesLocation.path_to_file + SampleFilesLocation.file_by_format[file_extension],
                   file.path)
    end

    def self.files_by_extension(files, extension)
      extension_files = []
      files.each { |file| extension_files << file if file.end_with?(extension.to_s) }
      extension_files
    end
  end
end
