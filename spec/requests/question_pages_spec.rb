require 'spec_helper'

describe "Question pages" do
  subject { page }

  describe "new question page" do
    before do
      visit questions_new_path
    end

    it { should have_title(full_title("New Question")) }
    it { should have_content("Accept Terms of Service") }

    let(:submit) { "Post Question" }

    it "should have a link to the ToS" do
      should have_link('Terms of Service', href: terms_path)
    end

    before do
      fill_in "Question",         with: "Example Question"
      fill_in "Name",             with: "Example User"
      fill_in "Email",            with: "user@example.com"
      fill_in "Password",         with: "foobar"
      fill_in "Confirm Password", with: "foobar"
      fill_in "Zipcode",          with: "12345"
      check "user_terms"
    end

    describe "with invalid information as non-logged in" do
      

      it "should not create a question without question" do
        fill_in "Question",         with: ""
        expect { click_button submit }.not_to change(Question, :count)
      end

      it "should not accept without checkbox" do
        uncheck "user_terms"
        expect { click_button submit }.not_to change(Question, :count)
      end
    end

    describe "with valid information as non-logged in" do
      

      it "should create a question" do
        expect { click_button submit }.to change(Question, :count).by(1)
      end
    end
  end


  # describe "question show page" do
  #   before do
  #     @question = Question.new("test")
  #     visit question_show_path + '/' + @question.id.to_s
  #   end

  #   it { should have_title(full_title("Question")) }

  #   #TODO: test me
  # end


end
