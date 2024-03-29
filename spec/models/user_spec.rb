require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "123456", password_confirmation: "123456")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 101 }
    it { should_not be_valid }
  end

  describe "when email is not presend" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com foo@bar..com]

      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save

      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")
    end

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before do
      @user.password_confirmation = "mismatch"
    end

    it { should_not be_valid }
  end

  describe "when terms of service are not accepted" do
    before do
      @user.terms = "0"
    end

    it { should_not be_valid}
  end

  describe "when terms of service are accepted" do
    before do
      @user.terms = "1"
    end

    it { should be_valid}
  end

  describe "with a password that's too short" do
    before do
      @user.password = @user.password_confirmation = "a" * 5
    end

    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before do
      @user.save
    end

    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it "should equal authenticated user" do
        @user.should eq found_user.authenticate(@user.password)
      end
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "with vet_score" do
    before do
      @vet = build(:vet, :email => "simple@vet.com")
      @answered = create(:answered_question)
      @answered_vet = @answered.answers[0].user

      @thanked = create(:answered_and_thanked_question)
      @thanked_vet = @thanked.answers[0].user
      @agreed = create(:answered_and_agreed_question)
      @agreed_vet = @agreed.answers[0].user
    end

    it "calculates a score" do
      @vet.vet_score.should be_an(Integer)
    end

    it "returns 50 for default score" do
      @vet.vet_score.should be(50)
    end

    it "raises score for answers" do
      @answered_vet.vet_score.should be > 50
    end

    it "getting thanked raises score" do
      @answered_vet.vet_score.should be < @thanked_vet.vet_score
    end

    it "agreements are worth more than thank yous" do
      @thanked_vet.vet_score.should be < @agreed_vet.vet_score
    end

    it "limits points from one source" do
      (1..8).each do
        create(:answer, :question => @answered, :user => @answered_vet)
      end
      @answered_vet.vet_score.should be < 66
    end
  end
end
