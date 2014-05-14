FactoryGirl.define do
	factory :user do
		
		detail
		name "Ignor Amos"
		sequence(:email) { |n| "user#{n}@example.com" }
		password "bestpasswordever"
		password_confirmation "bestpasswordever"

		factory :client do
		end

		factory :second_client do
			email "second@client.com"
		end

		factory :vet do
			name "Steth O Scope"
			sequence(:email) { |n| "vet#{n}@example.com" }
			question_notification "nearby"
			is_vet true
			enabled true
			bio "test bio"
			association :detail, factory: :vet_detail

			factory :second_vet do
				email "second@vet.com"
			end
		end
	end
end