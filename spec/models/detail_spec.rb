require 'spec_helper'

describe Detail do
  before do
    @detail = Detail.new(zipcode: "12345")
  end

  subject { @detail }

  it { should respond_to(:zipcode) }

  it { should be_valid }

  describe "when zipcode is not present" do
    before { @detail.zipcode = " " }
    it { should_not be_valid }
  end

  describe "when zipcode is not number" do
    before { @detail.zipcode = "abc" }
    it { should_not be_valid }
  end

  describe "when zipcode is too long" do
    before { @detail.zipcode = "1234567" }
    it { should_not be_valid }
  end


end
