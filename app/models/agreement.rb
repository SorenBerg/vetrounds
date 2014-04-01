class Agreement < ActiveRecord::Base
  belongs_to :to, :class_name => :User
  belongs_to :from, :class_name => :User
  belongs_to :question
  belongs_to :answer

  validate :correct_user_type
  private
    def correct_user_type
      if not from.is_vet
        self.errors.add(:to, "Clients can't agree")
      end
      if not to.is_vet
        self.errors.add(:to, "Clients can't be agreed with")
      end
    end
end
