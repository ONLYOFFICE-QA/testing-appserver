# frozen_string_literal: true

require 'spec_helper'

test_manager = TestingAppServer::TestManager.new(suite_name: File.basename(__FILE__))

describe 'Documents Favorites' do
  before do
    main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
    my_documents = main_page.side_bar(:documents)
    @favorites = my_documents.documents_navigation(:favorites)
  end

  after do |example|
    test_manager.add_result(example, @test)
    @test.webdriver.quit
  end

  it '[Favorites] Actions menu button is disable' do
    expect(@favorites).not_to be_actions_enabled
  end
end
