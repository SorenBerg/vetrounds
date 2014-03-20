FactoryGirl.define do
	factory :detail do
		
		zipcode 12345

		factory :vet_detail do
			area_of_practise "Critters"
			vetinary_school "Some guy"
			vetinary_school_year 1945
			degree "Cardboard plaque"
			licence_number 5
			licence_state "TX"
		end
	end
end