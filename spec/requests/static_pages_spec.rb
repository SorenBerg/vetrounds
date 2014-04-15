require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    before do
      visit root_url
    end

    it "should have the content 'How does it work ?'" do
      expect(page).to have_content("How does it work ?")
    end

    it "should have the page title 'Home | Vetrounds'" do
      expect(page).to have_title("Home | Vetrounds")
    end

    it "should have some active content" do
      expect(page).to have_content("blah")
    end

    describe "about us modal" do
      let (:modal) { find(:css, "#about-modal") }

      it "should have an about us modal" do
        click_link "About Us"
        modal.should have_content "Soren Berg"
        modal.click_button "Done"
      end
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

  describe "Terms of Service Page" do
    it "should have the ToS" do
      visit terms_url
      expect(page).to have_content("Terms of Service")
    end
  end
end
