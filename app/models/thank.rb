class Thank < ActiveRecord::Base
  belongs_to :to, :class_name => :User
  belongs_to :from, :class_name => :User
  belongs_to :question
  belongs_to :answer

  validate :correct_user_type
  private
    def correct_user_type
      if from.is_vet
        self.errors.add(:to, "Vets can't thank")
      elsif not to.is_vet
        self.errors.add(:to, "Clients can't be thanked")
      end
    end
end
