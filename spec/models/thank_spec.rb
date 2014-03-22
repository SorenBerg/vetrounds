require 'spec_helper'

describe Thank do
  describe "answered and thanked question" do
    before do
      @question = create(:answered_and_thanked_question)
    end

    it "can find count of thanks for user" do
      user = @question.user
      user.thanks.count.should eq(1)
      user.thanked.count.should eq(0)
    end

    it "can find count of thanked for vet" do
      vet = @question.answers[0].user
      vet.thanks.count.should eq(0)
      vet.thanked.count.should eq(1)
    end
  end

  describe "with invalid input" do

  	it "should not accept thanks from vet" do
  		build(:thank, from: build(:vet, email: "fakevet@example.com")).should_not be_valid
  	end

  	it "should not accept thanks to client" do
  		build(:thank, to: build(:client, email: "fakeclient@example.com")).should_not be_valid
  	end
  end
end
