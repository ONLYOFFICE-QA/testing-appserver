# frozen_string_literal: true

require_relative '../testing_appserver/data/private_data'

module TestingAppServer
  # User data
  class PersonalUserData
    PERSONAL_DEFAULT_ADMIN_NAME = 'admin-zero'
    PERSONAL_DEFAULT_ADMIN_LASTNAME = 'admin-zero'

    attr_accessor :portal, :mail, :pwd, :first_name, :last_name

    def initialize(user_data = {})
      secret_data = PrivateData.new.decrypt
      @portal = user_data.fetch(:portal, default_server)
      @mail = user_data.fetch(:mail, secret_data['portal_mail_admin'])
      @pwd =  user_data.fetch(:pwd, secret_data['portal_password_admin'])
      @first_name = user_data.fetch(:first_name, PERSONAL_DEFAULT_ADMIN_NAME)
      @last_name = user_data.fetch(:last_name, PERSONAL_DEFAULT_ADMIN_LASTNAME)
    end

    # @return [String] server on which test are performed
    def default_server
      return 'https://personal.onlyoffice.com' if ENV['SPEC_REGION']&.include?('com')

      'https://personal.teamlab.info'
    end
  end
end
