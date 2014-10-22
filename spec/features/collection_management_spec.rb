require "rails_helper"

feature "Collection creation" do
  scenario "Admin creates a new collection" do
    visit "/collections"
    click_button "New"
    expect(page).to have_text("Title")
  end
end
