require "rails_helper"
require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Collection creation" do

  before(:each) do
    @user = User.new(username: 'jhartzle')
    @user.save!
    login_as @user
  end
  
  scenario "Admin can access new collection page" do
    visit "/collections"
    click_link "New"
    expect(page).to have_text("Title")
  end

  scenario "Admin can create new collection" do
    visit "/collections/new"
    within("#new_collection") do
      fill_in 'Title', with: 'Test Collection'
    end
    click_button 'Create Collection'
    expect(page).to have_content 'Test Collection'
  end
end
