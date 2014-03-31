require 'spec_helper'

describe Question do
  before do
    @question = Question.new(content: "Foobar")
  end

  subject { @question }

  it { should respond_to(:content) }

  it { should be_valid }

  describe "when content is not present" do
    before { @question.content = " " }
    it { should_not be_valid }
  end

  describe "when gender is invalid" do
    before { @question.gender = Question::GENDER["Whazat"]  }
    it { should_not be_valid }
  end

  describe "when gender is valid" do
    before { @question.gender = Question::GENDER["Male"] }
    it { should be_valid }
  end

  describe "when signalment is invalid" do
    before { @question.signalment = Question::SIGNALMENT["Whazat"] }
    it { should_not be_valid }
  end

  describe "when signalment is valid" do
    before { @question.signalment = Question::SIGNALMENT["Intact"] }
    it { should be_valid }
  end

  describe "when breed is invalid" do
    before { @question.breed = Question::BREED["Whazat"] }
    it { should_not be_valid }
  end

  describe "when breed is selected but detail is invalid" do
    before do
      @question.breed = Question::BREED["Specify breed"]
      @question.breed_detail = ""
    end
    it { should_not be_valid }
  end

  describe "when breed and breed_detail are valid" do
    before do
      @question.breed = Question::BREED["Specify breed"]
      @question.breed_detail = "Some kind of thing"
    end
    it { should be_valid }
  end

  describe "when breed is unknown" do
    before do
      @question.breed = Question::BREED["Not sure"]
      @question.breed_detail = ""
    end
    it { should be_valid }
  end

  describe "search" do
    before do
      @question = create(:answered_question)
    end

    it "finds question text" do
      Question.search("cat").count.should eq(1)
    end

    it "finds answer text" do
      Question.search("dunno").count.should eq(1)
    end

    it "finds nothing if no matches" do
      Question.search("asfdsdfgf").count.should eq(0)
    end
  end

  #TODO: test question link to thanks/agreements
end
