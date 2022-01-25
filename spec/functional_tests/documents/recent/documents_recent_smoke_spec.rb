# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

describe 'Documents Recent' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    my_documents = main_page.top_toolbar(:documents)
    @recent = my_documents.documents_navigation(:recent)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Recent] Actions menu button is disable' do
    expect(@recent).not_to be_actions_enabled
  end
end
