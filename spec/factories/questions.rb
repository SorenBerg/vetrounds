FactoryGirl.define do
	factory :question do
		user
		content "Why is cat?"

		factory :answered_question do
			after(:create) do |instance|
				instance.answers << create(:answer, :question => instance)
			end
		end
	end
end