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
end
