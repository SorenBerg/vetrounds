FactoryGirl.define do
  factory :answer do
    association :user, factory: :vet
    question
    answer "I dunno"

    factory :thanked_answer do
      after(:create) do |instance|
        create(:thank, 
          :question => instance.question,
          :answer => instance,
          :from => instance.question.user,
          :to => instance.user)
      end
    end

    factory :agreed_answer do
      after(:create) do |instance|
        create(:agreement, 
          :question => instance.question,
          :answer => instance,
          :from => create(:vet, :email => "agreevet@example.com", :name => "Another Vet"),
          :to => instance.user)
      end
    end

    factory :thanked_and_agreed_answer do 
      after(:create) do |instance|
        create(:thank, 
          :question => instance.question,
          :answer => instance,
          :from => instance.question.user,
          :to => instance.user)
        create(:agreement, 
          :question => instance.question,
          :answer => instance,
          :from => create(:vet, :email => "agreevet@example.com", :name => "Another Vet"),
          :to => instance.user)
        
      end
    end
  end
end