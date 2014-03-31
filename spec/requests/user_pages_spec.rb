require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Join Today") }
    it { should have_title(full_title("Signup")) }
    it { should have_content("Accept Terms of Service") }

    let(:submit_client) { "Sign Up as Pet Owner" }
    let(:submit_vet) { "Sign Up as Doctor" }

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

  describe "user profile page as user" do

    before do
      @user = create(:client)
      log_in_as(@user)
      visit user_show_path({:id => @user.id})
    end

    it "contains user info" do
      should have_selector("h2", :text => "My Profile")
      should have_content(@user.name)
      should have_content(@user.email)
      should have_content(@user.detail.zipcode)
    end
  end

  describe "user profile page as user with question" do

    before do
      @question = create(:answered_and_thanked_question)
      @user = @question.user
      log_in_as(@user)

      visit user_show_path({:id => @user.id})
    end

    it "contains question heading" do
      should have_selector("h3", :text => "1 Question:")
    end

    it "contains questions" do
      should have_link(@user.questions[0].content, question_show_path(:id => @question.id))
    end

    it "shows thank you" do
      should have_content("1 Thank you given")
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

    it "shows 0 thank you's" do
      should have_content("0 Thank you's given")
    end

    it "should not show heading with no questions" do
      should_not have_content("Question")
    end
  end

  describe "vet profile page as vet" do

    before do
      @question = create(:answered_and_thanked_question)
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

    it "contains picture upload button" do
      should have_button("Upload Photo")
    end

    it "contains answered question" do
      should have_link(@question.content, question_show_path(:id => @question.id))
    end

    it "shows thank you's per question" do
      #counting header
      page.all('table#answers tr').count.should == 2
      questions_row = page.all('table#answers tr')[1].all('td')
      questions_row[0].text.should eq("1")
      questions_row[1].text.should eq(@question.content)
    end

    it "has notification settings" do
      should have_selector("label", :text => "Notification settings")
      should have_content("Notify me when a new question is asked:")
    end

    it "can update notification preferences" do
      find("option[value='all']").select_option
      click_button "Save"
      @vet.reload
      @vet.question_notification.should eq("all")
      
    end
  end

  describe "vet profile page as other user" do

    before do
      @user = create(:user)
      @vet = create(:vet)
      log_in_as(@user)
      visit user_show_path({:id => @vet.id})
    end

    it "does not have vet personal info" do
      should have_content(@vet.name)
      should_not have_content(@vet.email)
      should_not have_content(@vet.detail.license_number)
    end

    it "does not have have feedback if zero" do
      should_not have_content "Thank You Note"
      should_not have_content "Doctor Agreement"
    end

    it "does not have picture upload button" do
      should_not have_button("Upload")
    end

    it "does not have notification settings" do
      should_not have_content("Notification")
    end

    it "should not show heading with no answers" do
      should_not have_content("Answered Question")
    end
  
  end

  describe "vet profile page with feedback" do
    it "has thank you and doctor agreement numbers and answers" do
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
      should have_selector("h3", :text => "1 Answered Question:")
    end
  end
end
