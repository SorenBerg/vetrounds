FactoryGirl.define do
	factory :user do
		
		detail
		name "Ignor Amos"
		email "Huh@what.com"
		password "bestpasswordever"
		password_confirmation "bestpasswordever"

		factory :client do
		end

		factory :vet do
			name "Steth O Scope"
			email "vet@someplace.com"
			is_vet true
			enabled true
			association :detail, factory: :vet_detail
		end
	end
end