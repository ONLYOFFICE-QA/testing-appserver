# frozen_string_literal: true

require_relative '../../modules/people/modules/people_helper'

module TestingAppServer
  # Api helper methods for People module
  class PeopleApi
    include PeopleHelper

    # @return [Array] List of all portal users
    def all_portal_users
      Teamlab.people.filter_people(nil).body['response']
    end

    # @param name [String] Group name
    # @param manager [String] Group manager ID
    # @param members [Array] List of group members IDs
    # @return [Hash] Created group info
    def add_group(name, manager = nil, members = nil)
      Teamlab.group.add_group(manager, name, members).body['response']
    end

    # @param group_id [String] Group ID
    # @return [Hash] Deleted group info
    def delete_group(group_id)
      Teamlab.group.delete_group(group_id).body['response']
    end

    # @param mail [String] User mail
    # @return [Boolean] Specifies if user with this email exist or not
    def user_with_email_exist?(mail)
      user_list = all_portal_users
      return false if user_list.empty?

      user_list.each do |current_user|
        return true if mail == current_user['email']
      end
      false
    end

    # @param query [String] Search query
    # @return [Array] List of users
    def user_data_by_query(query)
      Teamlab.people.search_people(query).body['response']
    end

    # @param mail [String] User mail
    # @return [Hash] Deleted user info
    def delete_user_by_email(mail)
      user_id = user_data_by_query(mail)[0]['id']
      Teamlab.people.change_people_status('2', [user_id]).body['response']
      Teamlab.people.delete_user(user_id).body['response']
    end

    # @param user_data [Object] TestingAppServer::UserData - data for user to create
    # @return [Hash] Created user info
    def add_user(user_data)
      options = {
        isVisitor: (user_data.type == :guest),
        email: user_data.mail,
        firstname: user_data.first_name,
        lastname: user_data.last_name,
        password: user_data.pwd
      }
      Teamlab.people.active(options).body['response']
    end
  end
end
