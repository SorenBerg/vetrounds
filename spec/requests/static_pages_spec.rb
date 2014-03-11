require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    it "should have the content 'So how exactly does it work ?'" do
      visit root_url
      expect(page).to have_content("So how exactly does it work ?")
    end

    it "should have the page title 'Home | Vetrounds'" do
      visit root_url
      expect(page).to have_title("Home | Vetrounds")
    end
  end
end
