class Detail < ActiveRecord::Base
  belongs_to :user

  validates :zipcode, presence: true
end
