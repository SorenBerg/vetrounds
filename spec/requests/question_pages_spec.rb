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
      fill_in "Question",         with: question_content
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
          click_link question_content
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
      fill_in "question", with: question_content, match: :first
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

  describe "new question page logged in as vet" do
    before do
      @user = create(:vet)
      log_in_as(@user)
      #get to the new question page via POST
      visit root_url
      fill_in "question", with: question_content, match: :first
      click_button "Ask Question", match: :first
    end

    it "creates a consult" do
      click_button submit
      visit list_consults_path
      should have_content question_content
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
      click_button "Thank"
      expect { click_button "Done", :exact => true }.to change(Thank, :count).by(1)
      should have_link "Thanked"
      expect { click_link "Thanked" }.to change(Thank, :count).by(-1)
      should have_button "Thank"
    end

    it "allows user to send thank you note" do
      click_button "Thank"
      find(:css, "#thank_feedback", visible: true).set("Thank you so much!")
      click_button "Done", :exact => true
      should have_content "#{@question.user.name}: Thank you so much!"
      should have_link "Thanked"
    end

    it "thank with generic message" do
      click_button "Thank"
      click_button "Done"
      should have_content "#{@question.user.name}: Thank You!"
    end

    it "allows user to request appointment" do
      click_button "Request Appointment"
      find(:css, "#request", visible: true).set("Example Request")
      click_button "Send Request"
      should have_content "Request sent"
      # if this test goes flaky add sleep for quick fix or mock
      email = ActionMailer::Base.deliveries.last
      email.to.should eq [answer.user.email]
      email.to_s.include?(client.name).should be true
      email.to_s.include?("Example Request").should be true
    end

    it "allows user to share answer" do
      click_button "Share"
      fill_in "Name",  :with => "Test Name"
      fill_in "Email", :with => "test@example.com"
      click_button "Share Answer"
      # if this test goes flaky add sleep for quick fix or mock
      email = ActionMailer::Base.deliveries.last
      email.to.should eq ["test@example.com"]
      email.to_s.include?("Test Name").should be true
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

  describe "question list" do
    before do
      @consult = create(:consult)
      @vet = @consult.user
      log_in_as(@vet)
      @question = create(:question, :content => "Why is dog?")
      @answered_question = create(:answered_question, :user => create(:user, :email => "second@example.com"))
      visit list_questions_path
    end

    let(:answered) {find(:css, "#ans-q")}
    let(:unanswered) {find(:css, "#uans-q")}

    it "show unanswered questions by default" do
      unanswered.should have_content "Why is dog?"
      # answered
      unanswered.should_not have_content "Why is cat?"
      # consult
      unanswered.should_not have_content "Why is horse?"
    end

    it "show answered questions" do
      click_link "Answered Questions"
      answered.should have_content "Why is cat?"
      # unanswered
      answered.should_not have_content "Why is dog?"
      
    end

    it "show unanswered consults" do
      click_link "Consults"
      unanswered.should have_content "Why is horse?"
      # not consult
      unanswered.should_not have_content "Why is dog?"
    end

    it "allows new consults" do
      click_link "Request Consult"
      fill_in "Question", with: question_content
      click_button submit
      should have_content question_content
    end
  end
end
