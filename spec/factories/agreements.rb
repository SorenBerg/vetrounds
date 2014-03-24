FactoryGirl.define do
	factory :agreement do
		question
		answer { question.answers[0] }
		from { build(:vet, email: "agreeing@example.com")}
		to { build(:vet, email: "agreed@example.com")}

		after(:create) do |instance|
			instance.from.save!
			instance.to.save!
		end
	end
end