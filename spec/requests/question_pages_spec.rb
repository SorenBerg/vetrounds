require 'spec_helper'

describe "Question pages" do
  subject { page }
  let(:submit) { "Post Question" }
  let(:question_content) { "Example Question" }

  describe "new question page not logged in" do
    before do
      visit questions_new_path
    end

    it { should have_title(full_title("New Question")) }
    it { should have_content("Accept Terms of Service") }

    it "should have a link to the ToS" do
      should have_link('Terms of Service', href: terms_path)
    end

    before do
      fill_in "Question",         with: :question_content
      fill_in "Name",             with: "Example User"
      fill_in "Email",            with: "user@example.com"
      fill_in "Password",         with: "foobar"
      fill_in "Confirm Password", with: "foobar"
      fill_in "Zipcode",          with: "12345"
      check   "user_terms"
    end

    describe "with invalid information" do
      

      it "should not create a question without question" do
        fill_in "Question",         with: ""
        expect { click_button submit }.not_to change(Question, :count)
      end

      it "should not accept without checkbox" do
        uncheck "user_terms"
        expect { click_button submit }.not_to change(Question, :count)
      end
    end

    describe "with valid information" do
      

      it "should create a question" do
        expect { click_button submit }.to change(Question, :count).by(1)
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context "filling out all fields" do
        before do
          #question fields
          select  "Dog",              :from => "question_animal_type"
          select  "Female",           :from => "question_gender"
          select  "Intact",           :from => "question_signalment"
          select  "Specify breed",    :from => "question_breed"
          fill_in "question_breed_detail",       :with => "Great Dane" 
        end

        it "has all correct info for question" do
          click_button submit
          # navigate to question show page
          click_link :question_content
          should have_content "Dog"
          should have_content "Female"
          should have_content "Intact"
          should have_content "Great Dane"
        end
      end
    end
  end

  describe "new question page logged in via POST" do
    before do
      @user = create(:client)
      log_in_as(@user)
      #get to the new question page via POST
      visit root_url
      fill_in "question", with: :question_content, match: :first
      click_button "Ask Question", match: :first
    end

    context "filling out all fields" do
      before do
        select  "Dog",              :from => "question_animal_type"
        select  "Female",           :from => "question_gender"
        select  "Intact",           :from => "question_signalment"
        select  "Specify breed",    :from => "question_breed"
        fill_in "question_breed_detail",       :with => "Great Dane" 
      end

      it "has all correct info for question" do
        click_button submit
        # loged in users go straight to question page
        should have_content "Dog"
        should have_content "Female"
        should have_content "Intact"
        should have_content "Great Dane"
      end
    end
  end

  describe "question show page as user" do

    before do
      @question = create(:answered_question)
      log_in_as(@question.user)

      visit question_show_path({:id => @question.id})
    end

    let (:client) { @question.user }
    let (:answer) { @question.answers[0] }

    it "contains question" do
      should have_content(@question.content)
    end

    it "contains user info" do
      should have_content(client.name)
      should have_content(client.detail.zipcode)
    end

    it "contains answer" do
      should have_content(answer.answer)
    end

    it "contains link to vet profile" do
      should have_link(answer.user.name, href: user_show_path(:id => answer.user.id))
    end

    it "allows user to thank and unthank vet" do
      expect { click_link "Thank" }.to change(Thank, :count).by(1)
      should have_link "Thanked"
      expect { click_link "Thanked" }.to change(Thank, :count).by(-1)
      should have_link "Thank"
    end

    it "allows user to send thank you note" do
      click_link "Thank"
      fill_in "Include a thank you note", :with => "Thank you so much!"
      click_button "Send"
      should have_content "#{@question.user.name}: Thank you so much!"
      should have_link "Thanked"
      should_not have_button "Send"
    end

    it "shows generic thanks message" do
      click_link "Thank"
      should have_content "#{@question.user.name}: Thanks"
    end

    it "should have headings" do
      should have_selector("h2", :text => "Question")
      should have_selector("h2", :text => "1 Answer")
    end

    it { should have_title(full_title("Question")) }
  end

  describe "question show page as vet" do

    before do
      @question = create(:answered_question)
      @vet = create(:vet, :email => "NewVet@example.com", :name => "NewVet")
      log_in_as(@vet)
      visit question_show_path({:id => @question.id})
    end

    let (:newAnswer) { "I dunno either" }

    it "allows vet to aggree with answer" do
      expect { click_link "Agree" }.to change(Agreement, :count).by(1)
      should have_link "Agreed"
      expect { click_link "Agreed" }.to change(Agreement, :count).by(-1)
      should have_link "Agree"
    end

    it "allows vet to answer question" do
      fill_in "Your Answer", with: :newAnswer
      expect { click_button "Answer Question" }.to change(Answer, :count).by(1)
      should have_content(:newAnswer)
      should have_link(@vet.name, href: user_show_path(:id => @vet.id))
      should have_selector("h2", :text => "2 Answers")
    end
  end

  describe "unanswered question" do
    before do
      @question = create(:question)
      log_in_as(@question.user)
      visit question_show_path({:id => @question.id})
    end

    it "should not have answer heading" do
      should_not have_selector("h2", :text => "Answers")
      should_not have_selector("h2", :text => "Answer")
    end
  end
end
