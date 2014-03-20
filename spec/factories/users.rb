FactoryGirl.define do
	factory :user do
		
		detail
		name "Ignor Amos"
		email "Huh@what.com"
		password "bestpasswordever"
		password_confirmation "bestpasswordever"

		factory :client do
			detail
		end

		factory :vet do
			email "vet@someplace.com"
			association :detail, factory: :vet_detail
		end
	end
end