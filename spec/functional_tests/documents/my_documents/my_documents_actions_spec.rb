# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

admin = TestingAppServer::UserData.new
api_admin = TestingAppServer::ApiHelper.new(admin.portal, admin.mail, admin.pwd)

describe 'My Documents Actions menu' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    @documents_page = main_page.top_toolbar(:documents)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it_behaves_like 'documents_actions_button', 'AppServer', 'My Documents', api_admin
end
