require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    before do
      visit root_url
    end

    it "should have the page title 'Home | Vetrounds'" do
      expect(page).to have_title("Home | Vetrounds")
    end

    describe "about us modal" do
      let (:modal) { find(:css, "#about-modal") }

      it "should have an about us modal" do
        click_link "About Us"
        modal.should have_content "Soren Berg"
        modal.click_button "Done"
      end
    end

    describe "client section" do
      before do
        click_button "Pet Owner"
      end

      describe "question box" do
        before do
          @test = "test question"
          fill_in "question", with: @test, match: :first
          click_button "Ask Question", match: :first
        end

        it "should go to new question path" do
          current_path.should eq(home_question_post_path)
        end

        it "should pre-fill question" do
          page.should have_content @test
        end  
      end
    end

    describe "vet section" do
      before do
        find(:css, "#vet-button").click
      end

      it "should allow sign ups" do
        find(:css, "#vet-content").click_link "Sign Up"
        current_path.should eq(signup_path)
      end
    end

    # describe "active content" do
    #   before do
    #     @answer1 = create(:answered_question, :user => create(:second_client)).answers[0]
    #     @answer2 = create(:thanked_answer, :user => create(:second_vet))
    #   end

    #   it "should have active content" do
    #     page.should have_content @answer1.user.name
    #     page.should have_content @answer1.question.content
    #     page.should have_content @answer2.user.name
    #     page.should have_content @answer2.question.content
    #   end
    # end
  end

  describe "Terms of Service Page" do
    it "should have the ToS" do
      visit terms_url
      expect(page).to have_content("Terms of Service")
    end
  end
end
