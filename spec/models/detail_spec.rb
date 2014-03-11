require 'spec_helper'

describe Detail do
  before do
    @detail = Detail.new(zipcode: "123456")
  end

  subject { @detail }

  it { should respond_to(:zipcode) }

  it { should be_valid }

  describe "when zipcode is not present" do
    before { @detail.zipcode = " " }
    it { should_not be_valid }
  end
end
