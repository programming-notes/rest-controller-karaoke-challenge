require 'spec_helper'

# These are INTEGRATION TESTS

feature "Address Management" do

  before(:each) do
    @joe = Contact.create! name: "Joe Blow", email: "joeblow@example.com"
    @address = @joe.addresses.create! street: "633 Folsom St", state: "California", city: "San Francisco", zip: "94107"
  end

  after(:each) do
    Contact.delete_all
    Address.delete_all
  end

  scenario "sucessfully creates an address and displays the result" do
    visit "/contacts/#{@joe.id}"
    click_link "New Address"
    fill_in "Street", with: "123 happy trail"
    fill_in "City", with: "Cincinnati"
    fill_in "State", with: "Ohio"
    fill_in "Zip", with: "45240"
    click_button "Save"
    expect(page).to have_content("123 happy trail")
    expect(page).to have_content(@joe.name)
  end

  scenario "successfully updates an address and displays the result" do
    visit "/contacts/#{@joe.id}/addresses/#{@address.id}/edit"
    fill_in "Street", with: "334 Other Way"
    click_button "Save"
    expect(page).to have_content("Other Way")
    expect(page).to have_content(@joe.name)
  end
end
