# frozen_string_literal: true

shared_examples_for 'documents_favorite_smoke' do |product, all_files|
  it "[#{product}][Favorites] Actions menu button is disable" do
    expect(@favorites).not_to be_actions_enabled
  end

  it "[#{product}][Favorites] All files marked as favorite are in `Favorite` folder" do
    expect(@favorites).to be_files_present(all_files)
  end

  it "[#{product}][Favorites] `Select all` Filters are present" do
    pending('https://bugzilla.onlyoffice.com/show_bug.cgi?id=56391')
    expect(@favorites).to be_select_all_filters_for_favorites_present
  end
end
