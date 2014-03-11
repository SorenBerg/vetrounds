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
end
