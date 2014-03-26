require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Join Today") }
    it { should have_title(full_title("Signup")) }
    it { should have_content("Accept Terms of Service") }

    let(:submit_client) { "Sign Up as Pet Owner" }
    let(:submit_vet) { "Signup as Doctor" }

    it "should have a link to the ToS" do
      should have_link('Terms of Service', href: terms_path)
    end

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
        find(:css, "#client_new_user #user_terms").set("1")
      end

      it "should create a client" do
        expect { click_button submit_client }.to change(User, :count).by(1)
      end
    end

    # Doctor sign up disabled temporarily
    # describe "with invalid information for doctor" do
    #   it "should not create a doctor" do
    #     expect { click_button submit_vet }.not_to change(User, :count)
    #   end
    # end

    # describe "with valid information for doctor" do
    #   before do
    #     find(:css, "#vet_new_user #user_name").set("Example User")
    #     find(:css, "#vet_new_user #user_email").set("user@example.com")
    #     find(:css, "#vet_new_user #user_password").set("foobar")
    #     find(:css, "#vet_new_user #user_password_confirmation").set("foobar")
    #     find(:css, "#vet_new_user #user_detail_attributes_zipcode").set("12345")
    #   end

    #   it "should create a client" do
    #     expect { click_button submit_vet }.to change(User, :count).by(1)
    #   end
    # end
  end

  describe "user profile page as user" do

    before do
      @question = create(:question)
      @user = @question.user
      log_in_as(@user)

      visit user_show_path({:id => @user.id})
    end

    it "contains user info" do
      should have_selector("h2", :text => "My Profile")
      should have_content(@user.name)
      should have_content(@user.email)
      should have_content(@user.detail.zipcode)
    end

    it "contains questions" do
      should have_link(@user.questions[0].content, question_show_path(:id => @question.id))
    end
  end

  describe "user profile page as other user" do

    before do
      @user = create(:user)
      @secondUser = create(:user, :email => "secondUser@example.com")
      log_in_as(@secondUser)
      visit user_show_path({:id => @user.id})
    end

    it { should have_title(full_title("Profile")) }

    it "does not have email or zipcode" do
      should have_content(@user.name + "'s Profile")
      should_not have_content(@user.email)
      should_not have_content(@user.detail.zipcode)
    end
/!
    it "should have thank you's" do
      should have_content("0 Thank you's given")
    end
-!/
  end

  describe "vet profile page as vet" do

    before do
      @question = create(:answered_question)
      @vet = @question.answers[0].user
      log_in_as(@vet)
      visit user_show_path({:id => @vet.id})
    end

    it "contains vet info" do
      should have_content(@vet.name)
      should have_content(@vet.email)
      should have_content(@vet.detail.zipcode)
      should have_content(@vet.detail.area_of_practice)
      should have_content(@vet.detail.veterinary_school)
      should have_content(@vet.detail.veterinary_school_year)
      should have_content(@vet.detail.degree)
      should have_content(@vet.detail.license_number)
      should have_content(@vet.detail.license_state)
    end

    it "contains answered question" do
      should have_link(@question.content, question_show_path(:id => @question.id))
    end
  end

  describe "vet profile page as other user" do

    before do
      @user = create(:user)
      @vet = create(:vet)
      log_in_as(@user)
      visit user_show_path({:id => @vet.id})
    end

    it "does not have vet email" do
      should have_content(@vet.name)
      should_not have_content(@vet.email)
    end
/!
    it "has thanks" do
      should have_content "0 Thank You Notes"
      should have_content "0 Doctor Agreements"
    end
-!/  
  end

  describe "vet profile page with feedback" do
    it "has thank you and doctor agreement numbers" do
      @question = create(:answered_question)
      @vet = @question.answers[0].user
      log_in_as(@question.user)
      visit question_show_path({:id => @question.id})
      click_link "Thank"
      @newvet = create(:vet, :email => "NewVet@example.com", :name => "NewVet")
      log_in_as(@newvet)
      visit question_show_path({:id => @question.id})
      click_link "Agree"
      visit user_show_path({:id => @vet.id})

      should have_content "1 Thank You Note"
      should have_content "1 Doctor Agreement"
    end
  end
end
