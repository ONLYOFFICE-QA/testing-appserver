# frozen_string_literal: true

require 'yaml'

module TestingAppServer
  # Class for storing config parameters
  class PrivateData
    def initialize(file: "#{Dir.pwd}/lib/testing_appserver/data/private_data/data.yml.gpg",
                   pass_file: "#{Dir.home}/.config/onlyoffice/qa-testing-site-onlyoffice.yml")
      @file = file
      @pass_file = pass_file
      @pass = read_pass
    end

    # Decrypt encrypted file
    def decrypt
      encrypt_command = "echo '#{@pass}' | gpg --batch --yes --passphrase-fd 0 --decrypt #{@file} 2>/dev/null"
      result = `#{encrypt_command}`
      return no_password_message if result.empty?

      @data = YAML.safe_load(result)
    end

    private

    def no_password_message
      OnlyofficeLoggerHelper.log('No or incorrect password specified for private config. Using defaults')
      @data = {}
    end

    # @return [String] red private pass
    def read_pass
      YAML.load_file(@pass_file)['config_password']
    rescue Errno::ENOENT
      ''
    end
  end
end
