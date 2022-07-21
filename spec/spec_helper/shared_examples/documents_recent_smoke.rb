# frozen_string_literal: true

shared_examples_for 'documents_recent_smoke' do |all_files|
  it '[Recent] Actions menu button is disable' do
    expect(@recent).not_to be_actions_enabled
  end

  it '[Recent] Documents created and opened in My Documents exist in Recent' do
    all_files.each do |file|
      expect(@recent).to be_file_present(file)
    end
  end

  it '[Recent] `Select all` Filters are present' do
    @recent.check_file_checkbox(all_files[0])
    expect(@recent).to be_select_all_filters_for_recent_present
  end
end
