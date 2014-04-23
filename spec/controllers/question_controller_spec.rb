require 'spec_helper'

describe QuestionsController do
  context "new question" do
    context "without a user", type: :mailer do
      before do
        @user_attr = attributes_for(:user)
        @user_attr[:detail_attributes] = attributes_for(:detail)
      end

      let (:post_create) { post :create, question: attributes_for(:question), user: @user_attr }

      it "creates a user" do
        expect { 
          post_create
        }.to change(User,:count).by(1)
      end

      it "creates a question" do
        expect { 
          post_create
        }.to change(Question,:count).by(1)
      end

      context "sends notification email", type: :mailer do
        it "to user" do
          post_create
          ActionMailer::Base.deliveries.last.to.should eq [@user_attr[:email]]
        end

        it "with sendgrid header" do
          post_create
          sg = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"Unsubscribe <%Here%>","text/plain":"Unsubscribe Here: <% %>"}}}}'
          puts ActionMailer::Base.deliveries.last.header['X-SMTPAPI'].to_s.should eq(sg)
        end

        it "to vet with all notifications" do
          vet = create(:vet, :question_notification => 'all', :email => 'all@vet.com')
          post_create

          ActionMailer::Base.deliveries.last.to.should eq [vet.email]
        end

        it "to nearby vet with nearby notifications" do
          user_attr = attributes_for(:user)
          user_attr[:detail_attributes] = attributes_for(:detail)
          vet = create(:vet, :question_notification => 'nearby', :email => 'nearby@vet.com')
          post_create

          ActionMailer::Base.deliveries.last.to.should eq [vet.email]
        end
      end

      context "does not send email", type: :mailer do
        it "to vet with no notifications" do
          vet = create(:vet, :question_notification => 'none', :email => 'none@vet.com')
          post_create

          ActionMailer::Base.deliveries.length.should eq 1
        end

        it "to faraway vet with nearby notifications" do
          user_attr = attributes_for(:user)
          user_attr[:detail_attributes] = attributes_for(:detail)
          vet = create(:vet, :question_notification => 'nearby', :detail => create(:vet_detail, :zipcode => 54321))
          post_create

          ActionMailer::Base.deliveries.length.should eq 1
        end
      end  
    end
  end
end
