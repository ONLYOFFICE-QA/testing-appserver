# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

describe 'Documents Shared with me' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    my_documents = main_page.side_bar(:documents)
    @shared_with_me = my_documents.documents_navigation(:shared_with_me)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Shared with me] Actions menu button is disable' do
    expect(@shared_with_me).not_to be_actions_enabled
  end
end
