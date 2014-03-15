require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Join Today") }
    it { should have_title(full_title("Signup")) }

    let(:submit_client) { "Signup as Client" }
    let(:submit_vet) { "Signup as Doctor" }

    describe "with invalid information for client" do
      it "should not create a client" do
        expect { click_button submit_client }.not_to change(User, :count)
      end
    end

    describe "with valid information for client" do
      before do
        find(:css, "#client_new_user #user_name").set("Example User")
        find(:css, "#client_new_user #user_email").set("user@example.com")
        find(:css, "#client_new_user #user_password").set("foobar")
        find(:css, "#client_new_user #user_password_confirmation").set("foobar")
        find(:css, "#client_new_user #user_detail_attributes_zipcode").set("12345")
      end

      it "should create a client" do
        expect { click_button submit_client }.to change(User, :count).by(1)
      end
    end

    describe "with invalid information for doctor" do
      it "should not create a doctor" do
        expect { click_button submit_vet }.not_to change(User, :count)
      end
    end

    describe "with valid information for doctor" do
      before do
        find(:css, "#vet_new_user #user_name").set("Example User")
        find(:css, "#vet_new_user #user_email").set("user@example.com")
        find(:css, "#vet_new_user #user_password").set("foobar")
        find(:css, "#vet_new_user #user_password_confirmation").set("foobar")
        find(:css, "#vet_new_user #user_detail_attributes_zipcode").set("12345")
      end

      it "should create a client" do
        expect { click_button submit_vet }.to change(User, :count).by(1)
      end
    end
  end

  #TODO: test show page

end
