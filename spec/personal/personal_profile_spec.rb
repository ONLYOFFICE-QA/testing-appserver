# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::PersonalTestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::PersonalUserData.new

describe 'Personal Profile' do
  before do
    @test = TestingAppServer::PersonalTestInstance.new(admin)
    @documents_page = TestingAppServer::PersonalSite.new(@test).personal_login(admin.mail, admin.pwd)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '`Sign out` from personal works' do
    personal_main_page = @documents_page.top_user_menu(:sign_out)
    expect(personal_main_page.personal_login_element).to be_present
  end

  describe 'Personal Profile' do
    before { @personal_profile = @documents_page.top_user_menu(:profile) }

    it 'Personal Profile page is opened with correct email' do
      expect(@personal_profile.profile_full_email).to eq(admin.mail)
    end

    it 'Edit Personal Profile works: change Location' do
      location = Faker::Address.city
      edit_page = @personal_profile.edit_user
      personal_profile = edit_page.edit_user_location(location)
      expect(personal_profile.profile_location).to eq(location)
    end

    describe 'Forbidden content for personal' do
      it 'Top bar modules navigation is not present for Personal' do
        expect(@personal_profile).not_to be_all_top_toolbar_modules_navigation_present
      end

      it 'Action button is not present for Personal profile' do
        expect(@personal_profile.actions_element).not_to be_present
      end

      it 'Groups tree is not present for Personal profile' do
        expect(@personal_profile.groups_menu_element).not_to be_present
      end
    end
  end
end
