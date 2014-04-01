FactoryGirl.define do
	factory :thank do
		question
		answer { question.answers[0] }
		from { build(:client, email: "thanking@example.com")}
		to { build(:vet, email: "thanked@example.com")}
		feedback "What a great answer!"

		after(:create) do |instance|
			instance.from.save!
			instance.to.save!
		end
	end
end