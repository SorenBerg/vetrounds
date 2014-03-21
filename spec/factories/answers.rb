FactoryGirl.define do
	factory :answer do
		association :user, factory: :vet
		question
		answer "I dunno"
	end
end