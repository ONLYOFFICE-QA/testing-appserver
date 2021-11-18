# frozen_string_literal: true

require_relative 'private_data'

module TestingAppServer
  # User data
  class UserData
    DEFAULT_PORTAL = 'http://appserver.qa-onlyoffice.net/'
    DEFAULT_ADMIN_NAME = 'Administrator'
    DEFAULT_ADMIN_LASTNAME = ''

    attr_accessor :portal, :mail, :pwd, :first_name, :last_name, :type, :pwd_generation_type, :generate_pwd
    attr_reader :full_name

    def initialize(user_data = {})
      secret_data = PrivateData.new.decrypt
      @portal = user_data.fetch(:portal, DEFAULT_PORTAL)
      @mail = user_data.fetch(:mail, secret_data['portal_mail_admin'])
      @pwd =  user_data.fetch(:pwd, secret_data['portal_password_admin'])
      @first_name = user_data.fetch(:first_name, DEFAULT_ADMIN_NAME)
      @last_name = user_data.fetch(:last_name, DEFAULT_ADMIN_LASTNAME)
      @full_name = "#{@first_name} #{@last_name}"
      @type = user_data.fetch(:type, :admin)
      @pwd_generation_type = user_data.fetch(:pwd_generation_type, :temporary_pwd)
      @generate_pwd = user_data.fetch(:generate_pwd, false)
    end
  end
end
