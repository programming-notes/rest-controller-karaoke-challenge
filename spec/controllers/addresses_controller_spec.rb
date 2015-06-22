require 'spec_helper'

# These are CONTROLLER TESTS

describe "Address Controller" do

  before(:each) do
    @joe = Contact.create! name: "Joe Blow", email: "joeblow@example.com"
    @address = @joe.addresses.create! street: "633 Folsom St", state: "California", city: "San Francisco", zip: "94107"
  end

  after(:each) do
    Contact.delete_all
    Address.delete_all
  end

  describe "Getting the New Address Form" do
    it "displays the new form" do
      get "/contacts/#{@joe.id}/addresses/new"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("New address")
      expect(last_response.body).to include("Street")
      expect(last_response.body).to include("State")
      expect(last_response.body).to include("City")
      expect(last_response.body).to include("Zip")
    end
  end

  describe "Creating Addresses" do

    context "with valid input" do
      it "creates a new address" do
        expect{ post "/contacts/#{@joe.id}/addresses",
          { address: {street: "351 W Hubbard Street", city: "Chicago", state: "IL", zip: "60654"} }
        }.to change{ Address.count }.by(1)
      end

      it "redirects the user the contact's show page for which they were adding an address" do
        post "/contacts/#{@joe.id}/addresses",
        { address: {street: "351 W Hubbard Street", city: "Chicago", state: "IL", zip: "60654"} }
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("New Address")
        expect(last_response.body).to include("Addresses:")
        expect(last_response.body).to include("Edit contact")
        expect(last_response.body).to include("351 W Hubbard Street")
      end
    end

    context "with invalid input" do
      it "does not create a new address" do
        expect{ post "/contacts/#{@joe.id}/addresses",
          { address: {city: "Chicago", state: "IL", zip: "60654"} }
        }.not_to change{ Address.count }.by(1)
        expect(last_response.status).to eq(200)
      end

      it "renders the form the user came from so that they can fix errors" do
        post "/contacts/#{@joe.id}/addresses",
        { address: {city: "Chicago", state: "IL", zip: "60654"} }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("New address")
        expect(last_response.body).to include("Street")
        expect(last_response.body).to include("State")
        expect(last_response.body).to include("City")
        expect(last_response.body).to include("Zip")
        expect(last_response.body).to include("Chicago")
      end
    end
  end

  describe "Getting the Edit Address Form" do
    it "displays the edit form with prefilled info" do
      get "/contacts/#{@joe.id}/addresses/#{@address.id}/edit"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Edit address")
      expect(last_response.body).to include("633 Folsom St")
      expect(last_response.body).to include("Street")
      expect(last_response.body).to include("State")
      expect(last_response.body).to include("City")
      expect(last_response.body).to include("Zip")
    end
  end

  describe "Updating Addresses" do
    context "with valid input" do
      it "updates an address" do
        put "/contacts/#{@joe.id}/addresses/#{@address.id}",
          { address: {street: "351 W Hubbard Street", city: "Chicago", state: "IL", zip: "60654"} }
        @address.reload
        expect(@address.street).to eq("351 W Hubbard Street")
      end

      it "redirects the user the contact's show page for which they were adding an address" do
        put "/contacts/#{@joe.id}/addresses/#{@address.id}",
        { address: {street: "351 W Hubbard Street", city: "Chicago", state: "IL", zip: "60654"} }
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("New Address")
        expect(last_response.body).to include("Addresses:")
        expect(last_response.body).to include("Edit contact")
        expect(last_response.body).to include("351 W Hubbard Street")
      end
    end

    context "with invalid input" do
      it "does not edit an address" do
        put "/contacts/#{@joe.id}/addresses/#{@address.id}",
                { address: {street: nil, city: "Chicago", state: "IL", zip: "60654"} }
        @address.reload
        expect(@address.street).to eq("633 Folsom St")
        expect(last_response.status).to eq(200)
      end

      it "renders the form the user came from so that they can fix errors" do
        put "/contacts/#{@joe.id}/addresses/#{@address.id}",
            { address: {street: nil, city: "Chicago", state: "IL", zip: "60654"} }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Edit address")
        expect(last_response.body).to include("Street")
        expect(last_response.body).to include("State")
        expect(last_response.body).to include("City")
        expect(last_response.body).to include("Zip")
        expect(last_response.body).to include("Chicago")
      end
    end
  end

  describe "Deleting an address" do

    it "removes the address" do
      expect { delete "/contacts/#{@joe.id}/addresses/#{@address.id}" }.to change{ Address.count }.by(-1)
    end

    it "redirects the user the contact's show page for which they were deleting an address" do
      delete "/contacts/#{@joe.id}/addresses/#{@address.id}"
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("New Address")
      expect(last_response.body).to include("Addresses:")
      expect(last_response.body).to include("Edit contact")
      expect(last_response.body).not_to include("633 Folsom St")
    end
  end
end
