# frozen_string_literal: true

shared_examples_for 'documents_recent_smoke' do |new_document, new_spreadsheet, new_presentation|
  it '[Recent] Actions menu button is disable' do
    expect(@recent).not_to be_actions_enabled
  end

  it '[Recent] Documents created and opened in My Documents exist in Recent' do
    expect(@recent).to be_file_present(new_document)
    expect(@recent).to be_file_present(new_spreadsheet)
    expect(@recent).to be_file_present(new_presentation)
  end

  it '[Recent] `Select all` Filters are present' do
    expect(@recent).to be_select_all_filters_for_recent_present
  end
end
