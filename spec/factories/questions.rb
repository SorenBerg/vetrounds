FactoryGirl.define do
	factory :question do
		user
		content "Why is cat?"

		factory :answered_question do
			after(:create) do |instance|
				instance.answers << create(:answer, :question => instance)
			end
		end

		factory :answered_and_thanked_question do
			after(:create) do |instance|
				instance.answers << create(:thanked_answer, :question => instance)
			end
		end

		factory :answered_and_agreed_question do
			after(:create) do |instance|
				instance.answers << create(:agreed_answer, :question => instance)
			end
		end

		factory :answered_and_thanked_and_agreed_question do
			after(:create) do |instance|
				instance.answers << create(:thanked_and_agreed_answer, :question => instance)
			end
		end
	end
end