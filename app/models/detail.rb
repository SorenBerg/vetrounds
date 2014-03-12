class Detail < ActiveRecord::Base
  belongs_to :user

  validates :zipcode, length: { is: 5 }
  validates :zipcode, numericality: { only_integer: true }
end
