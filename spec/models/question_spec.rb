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
    before { @question.gender = 10 }
    it { should_not be_valid }
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
