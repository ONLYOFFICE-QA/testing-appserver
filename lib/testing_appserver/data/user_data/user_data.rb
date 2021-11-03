# frozen_string_literal: true

require_relative 'default_user_data'
require_relative '../../data/appserver_private_data'

module TestingAppServer
  # User data
  class UserData
    include DefaultUserData

    attr_accessor :portal, :mail, :pwd, :first_name, :last_name, :type

    def initialize(user_data = {})
      secret_data = AppServerPrivateData.new.decrypt
      @portal = user_data.fetch(:portal, DEFAULT_PORTAL)
      @mail = user_data.fetch(:mail, secret_data['portal_mail_admin'])
      @pwd =  user_data.fetch(:pwd, secret_data['portal_password_admin'])
      @first_name = user_data.fetch(:first_name, DEFAULT_ADMIN_NAME)
      @last_name = user_data.fetch(:last_name, DEFAULT_ADMIN_LASTNAME)
      @type = user_data.fetch(:type, :admin)
    end
  end
end
