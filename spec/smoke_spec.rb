# frozen_string_literal: true

require 'spec_helper'

describe 'Smoke check' do
  before do
    @main_page, @test = TestingAppServer::AppServerHelper.new.init_instance
  end

  after do |_example|
    @test.webdriver.quit
  end

  it 'All modules on main page present' do
    expect(@main_page).to be_all_modules_present
  end
end
