# frozen_string_literal: true

require 'spec_helper'

user = TestingAppServer::UserData.new(first_name: 'John', last_name: 'Smith', mail: TestingAppServer::UserData::USER_EMAIL,
                                      pwd: SecureRandom.hex(7), type: :user)

describe 'Create person' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @people_page = main_page.side_bar(:people)
  end

  after do |_example|
    @test.webdriver.quit
  end

  describe 'Create and delete user' do
    it 'Crete new user' do
      profile_page = @people_page.open_create_user_form_from_side_bar.create_new_user(user)
      expect(profile_page.profile_full_name).to eq(user.full_name)
    end

    it 'Delete user' do
      profile_page = @people_page.open_profile_by_full_name(user.full_name)
      profile_page.delete_person_from_profile
      people_page = profile_page.side_bar(:people) # TODO: delete line after fixing bug: Return to user list after deleting
      expect(people_page).to be_user_not_exist(user.full_name)
    end
  end
end
