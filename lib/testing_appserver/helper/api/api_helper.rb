# frozen_string_literal: true

require_relative 'documents_api'
require_relative 'people_api'

module TestingAppServer
  # Api authentication and helper methods
  class ApiHelper
    def initialize(portal, mail, pwd)
      Teamlab.configure do |config|
        config.server = portal
        config.username = mail
        config.password = pwd
      end
    end

    def people
      @people ||= PeopleApi.new
    end

    def documents
      @documents ||= DocumentsApi.new
    end
  end
end
