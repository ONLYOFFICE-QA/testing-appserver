# frozen_string_literal: true

require_relative '../../../helper/api/people_api'

module TestingAppServer
  # AppServer People module Helper methods
  module PeopleHelper
    def add_group_with_manager_names(name, manager: nil, members: nil)
      manager = get_people_id_by_full_name manager
      members = get_peoples_ids_by_names members
      add_group(name, manager, members)
    end

    def get_people_id_by_full_name(full_name)
      all_users = all_portal_users
      all_users.each do |current_user|
        return current_user['id'] if full_name == "#{current_user['firstName']} #{current_user['lastName']}"
      end
      nil
    end

    def get_peoples_ids_by_names(*full_names)
      people_ids = []
      full_names.flatten.each do |full_name|
        id = get_people_id_by_full_name(full_name)
        people_ids << id if id
      end
      people_ids
    end

    def delete_groups(groups_id_list)
      groups_id_list.each { |group_id| delete_group(group_id) }
    end
  end
end
