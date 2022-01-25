# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

describe 'Documents Private Room' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    my_documents = main_page.top_toolbar(:documents)
    @private_room = my_documents.documents_navigation(:private_room)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Private Room] Actions menu button is disable' do
    expect(@private_room).not_to be_actions_enabled
  end
end
