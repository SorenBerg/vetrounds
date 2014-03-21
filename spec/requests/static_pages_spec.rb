require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    it "should have the content 'How does it work ?'" do
      visit root_url
      expect(page).to have_content("How does it work ?")
    end

    it "should have the page title 'Home | Vetrounds'" do
      visit root_url
      expect(page).to have_title("Home | Vetrounds")
    end
  end

  describe "Terms of Service Page" do
    it "should have the ToS" do
      visit terms_url
      expect(page).to have_content("Terms of Service")
    end
  end
end
