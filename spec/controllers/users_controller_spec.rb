require 'spec_helper'
include SessionsHelper

describe UsersController do
  it "creates a user" do
    expect { 
      post :create_client, user: attributes_for(:user)
    }.to change(User,:count).by(1)
  end

  context "sends notification email", type: :mailer do
    before do
      @question = create(:answered_question)
      @user = @question.user
      @answer = @question.answers[0]
      @vet = @answer.user
      sign_in(@user)
      post :request_appointment, from_id: @user.id, to_id: @vet.id, answer_id: @answer.id, request: "test request"
    end

    it "should send an email to the vet" do 
      ActionMailer::Base.deliveries.last.to.should eq [@vet.email]
    end

    it "has the user's email and name" do
      body = ActionMailer::Base.deliveries.last.to_s
      body.should have_content(@user.email)
      body.should have_content(@user.name)
    end

    it "has the request text" do
      body = ActionMailer::Base.deliveries.last.encoded
      body.should have_content("test request")
    end

    it "has the senders name in the subject" do
      ActionMailer::Base.deliveries.last.subject.should eq("#{@user.name} requests an appointment")
    end

    it "has the answer text" do
      ActionMailer::Base.deliveries.last.to_s.should have_content(@answer.answer)
    end
  end
end