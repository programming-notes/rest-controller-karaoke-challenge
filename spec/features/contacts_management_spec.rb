require 'spec_helper'

# These are INTEGRATION TESTS

feature "Contacts Management" do

  before(:each) do
    @joe = Contact.create! name: "Joe Blow", email: "joeblow@example.com"
  end

  scenario "retrieves all contacts and displays them" do
    visit "/contacts"
    expect(page).to have_content(@joe.name)
  end

  scenario "creates contacts via the new contact form" do
    visit "/contacts/new"
    fill_in "Name", with: "Fred Person"
    fill_in "Email", with: "fred@example.com"
    click_button "Save"
    expect(page).to have_content("Fred Person")
  end

  scenario "edits contacts via the edit contact form" do
    visit "/contacts/#{@joe.id}/edit"
    fill_in "Name", with: "Not Joe"
    click_button "Save"
    expect(page).to have_content("Not Joe")
  end

  scenario "delete contacts via the delete button" do
    visit "/contacts/#{@joe.id}/edit"
    click_button "DELETE"
    expect(page).to have_content("Contacts")
    expect(page).not_to have_content("Joe Blow")
  end

  after(:each) do
    Contact.delete_all
  end
end
