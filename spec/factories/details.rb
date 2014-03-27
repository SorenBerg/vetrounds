FactoryGirl.define do
	factory :detail do
		
		zipcode 12345

		factory :vet_detail do
			area_of_practice "Critters"
			veterinary_school "Some guy"
			veterinary_school_year 1945
			degree "Cardboard plaque"
      license_number "4355345345asfsd"
			license_state "TX"
		end
	end
end