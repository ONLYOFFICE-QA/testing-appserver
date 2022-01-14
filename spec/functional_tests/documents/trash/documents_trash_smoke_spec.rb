# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

describe 'Documents Trash' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    my_documents = main_page.side_bar(:documents)
    @trash = my_documents.documents_navigation(:shared_with_me)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Trash] Actions menu button is disable' do
    expect(@trash).not_to be_actions_enabled
  end
end
