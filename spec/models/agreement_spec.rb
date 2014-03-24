require 'spec_helper'

describe Agreement do
  describe "answered and agreed question" do
    before do
      @question = create(:answered_and_agreed_question)
    end

    it "can find count of agreements for user" do
      vet2 = @question.answers[0].agreements[0].from
      vet2.agreements.count.should eq(1)
      vet2.agreed.count.should eq(0)
    end

    it "can find count of agreed for vet" do
      vet = @question.answers[0].user
      vet.agreements.count.should eq(0)
      vet.agreed.count.should eq(1)
    end
  end

  describe "with invalid input" do

    it "should not accept agreement from client" do
      build(:agreement, from: build(:client, email: "fakeclient@example.com")).should_not be_valid
    end

    it "should not accept agreement to client" do
      build(:agreement, to: build(:client, email: "fakeclient@example.com")).should_not be_valid
    end
  end
end
