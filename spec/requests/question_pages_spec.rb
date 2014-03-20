require 'spec_helper'

describe "Question pages" do
  subject { page }

  describe "new question page" do
    before do
      visit questions_new_path
    end

    it { should have_title(full_title("New Question")) }

    let(:submit) { "Post Question" }

    describe "with invalid information as non-logged in" do
      it "should not create a question" do
        expect { click_button submit }.not_to change(Question, :count)
      end
    end

    describe "with valid information as non-logged in" do
      before do
        fill_in "Question",         with: "Example Question"
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
        fill_in "Zipcode",          with: "12345"
      end

      it "should create a question" do
        expect { click_button submit }.to change(Question, :count).by(1)
      end
    end
  end

  describe "question show page" do

    before do
      @question = create(:answered_question)
      log_in_as(@question.user)

      visit question_show_path({:id => @question.id})
    end

    it "contains question" do
      should have_content(@question.content)
    end

    it "contains user info" do
      should have_content(@question.user.name)
      should have_content(@question.user.detail.zipcode)
    end

    it "contains answer" do
      should have_content(@question.answers[0].answer)
    end
    #it { should have_title(full_title("Question")) }

    #TODO: test me
  end


end
