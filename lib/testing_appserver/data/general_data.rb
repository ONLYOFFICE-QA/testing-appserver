# frozen_string_literal: true

module TestingAppServer
  # General AppServer data
  class GeneralData
    def self.generate_random_name(pattern)
      "#{pattern}_#{SecureRandom.hex(5)}"
    end

    def self.documents_accounts
      secret_data = PrivateData.new.decrypt
      {
        webdav: { url: 'https://webdav.yandex.ru', login: secret_data['documents_webdav_mail'],
                  pwd: secret_data['documents_webdav_pass'] },
        yandex: { login: secret_data['documents_yandex_mail'], pwd: secret_data['documents_yandex_pass'] }
      }
    end

    def self.webdav_accounts_files
      ['New_Folder_2_758825680', 'New_Folder_1_758815046', 'имя с пробелом_3.pptx', 'ann_test.xlsx', 'Collaborative.docx',
       'zip_with_txt.zip', 'э_picture_2.png']
    end

    def self.yandex_accounts_files
      ['New_Folder_2_60169265', 'New_Folder_1_60162991', 'имя с пробелом_3.pptx', 'ann_test.xlsx', 'Collaborative.docx',
       'zip_with_txt.zip', 'э_picture_2.png']
    end

    def self.download_formats
      {
        pptx: ['original', '.odp', '.pdf'],
        xlsx: ['original', '.csv', '.ods', '.pdf'],
        docx: ['original', '.docxf', '.odt', '.pdf', '.rtf', '.txt']
      }
    end
  end
end
