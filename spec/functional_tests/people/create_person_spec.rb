# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::UserData.new
user = TestingAppServer::UserData.new(first_name: 'John', last_name: 'Smith',
                                      mail: TestingAppServer::PrivateData.new.decrypt['user_mail'],
                                      pwd: SecureRandom.hex(7), type: :user)

describe 'Create person' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @people_page = main_page.side_bar(:people)
    @api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  describe 'User' do
    describe 'Create' do
      before { @api_admin.people.delete_user_by_email(user.mail) if @api_admin.people.user_with_email_exist?(user.mail) }

      it 'Crete new user' do
        profile_page = @people_page.open_create_user_form_from_side_bar.create_new_user(user)
        expect(profile_page.profile_full_name).to eq(user.full_name)
      end
    end

    describe 'Delete' do
      before do
        unless @api_admin.people.user_with_email_exist?(user.mail)
          @api_admin.people.add_user(user)
          @people_page.refresh
        end
      end

      it 'Delete user' do
        profile_page = @people_page.open_profile_by_full_name(user.full_name)
        profile_page.delete_person_from_profile
        people_page = profile_page.side_bar(:people) # TODO: delete line after fixing bug: Return to user list after deleting
        expect(people_page).to be_user_not_exist(user.full_name)
      end
    end
  end
end
