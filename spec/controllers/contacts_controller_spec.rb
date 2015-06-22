require 'spec_helper'

# These are CONTROLLER TESTS

describe "Contact Controller" do

  before(:each) do
    @joe = Contact.create! name: "Joe Blow", email: "joeblow@example.com"
  end

  after(:each) do
    Contact.delete_all
  end

  describe "Getting all contacts" do
    it "displays all contacts" do
      get "/contacts"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Joe Blow")
      expect(last_response.body).to include("joeblow@example.com")
      expect(last_response.body).to include("Contacts")
      expect(last_response.body).to include("Create Contact")
    end
  end

  describe "Getting one contact" do
    it "displays the page for one contact" do
      get "/contacts/#{@joe.id}"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Joe Blow")
      expect(last_response.body).to include("joeblow@example.com")
      expect(last_response.body).to include("New Address")
      expect(last_response.body).to include("Addresses:")
      expect(last_response.body).to include("Edit contact")
    end
  end

  describe "Getting the New Contact Form" do
    it "displays the new form" do
      get "/contacts/new"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("New contact")
      expect(last_response.body).to include("Name")
      expect(last_response.body).to include("Email")
    end
  end

  describe "Creating a Contact" do

    context "with valid input" do
      it "creates a new address" do
        expect{ post "/contacts",
          { contact: {name: "Casey Cumbow", email: "casey@devbootcamp.com"} }
        }.to change{ Contact.count }.by(1)
      end

      it "redirects the user all contacts page" do
        post "/contacts",
        { contact: {name: "Casey Cumbow", email: "casey@devbootcamp.com"} }
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Contacts")
        expect(last_response.body).to include("Create Contact")
        expect(last_response.body).to include("Casey Cumbow")
      end
    end

    context "with invalid input" do
      it "does not create a new contact" do
        expect{ post "/contacts", { contact: {name: nil, email: "casey@devbootcamp.com"} }
        }.not_to change{ Contact.count }.by(1)
        expect(last_response.status).to eq(200)
      end

      it "renders the form the user came from so that they can fix errors" do
        post "/contacts", { contact: {name: nil, email: "casey@devbootcamp.com"} }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("New contact")
        expect(last_response.body).to include("Name")
        expect(last_response.body).to include("Email")
        expect(last_response.body).to include("casey@devbootcamp.com")
      end
    end
  end

  describe "Getting the Edit Address Form" do
    it "displays the edit form with prefilled info" do
      get "/contacts/#{@joe.id}/edit"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Edit contact")
      expect(last_response.body).to include("Joe Blow")
      expect(last_response.body).to include("joeblow@example.com")
      expect(last_response.body).to include("Name")
      expect(last_response.body).to include("Email")
    end
  end

  describe "Updating Contacts" do
    context "with valid input" do
      it "updates an address" do
        put "/contacts/#{@joe.id}",
          { contact: {name: "Casey Cumbow", email: "casey@devbootcamp.com"} }
        @joe.reload
        expect(@joe.name).to eq("Casey Cumbow")
      end

      it "redirects the user all contacts page" do
        put "/contacts/#{@joe.id}",
        { contact: {name: "Casey Cumbow", email: "casey@devbootcamp.com"} }
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Contacts")
        expect(last_response.body).to include("Create Contact")
        expect(last_response.body).to include("Casey Cumbow")
      end
    end

    context "with invalid input" do
      it "does not edit an contact" do
        put "/contacts/#{@joe.id}",
                { contact: {name: nil, email: "casey@devbootcamp.com"} }
        @joe.reload
        expect(@joe.name).to eq("Joe Blow")
        expect(last_response.status).to eq(200)
      end

      it "renders the form the user came from so that they can fix errors" do
        put "/contacts/#{@joe.id}",
            { contact: {name: nil, email: "casey@devbootcamp.com"} }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Edit contact")
        expect(last_response.body).to include("casey@devbootcamp.com")
        expect(last_response.body).to include("Name")
        expect(last_response.body).to include("Email")
      end
    end
  end

  describe "Deleting an contact" do

    it "removes the contact" do
      expect { delete "/contacts/#{@joe.id}" }.to change{ Contact.count }.by(-1)
    end

    it "redirects the user to the all contacts page" do
      delete "/contacts/#{@joe.id}"
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Contacts")
      expect(last_response.body).to include("Create Contact")
      expect(last_response.body).not_to include("Joe Blow")
    end
  end
end