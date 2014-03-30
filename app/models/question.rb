class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :thanks
  has_many :agreements

  GENDER = { "Not sure" => 0, "Male" => 1, "Female" => 2 }

  validates :content, presence: true
  validates :gender, inclusion: { in: GENDER.values }

  
 
  def get_gender
    GENDER.key(read_attribute(:gender))
  end

  def self.search(search)
    if search && !search.blank?
      joins(:answers)
      .where(
        'content LIKE ? OR answers.answer LIKE ?',
        "%#{search}%",
        "%#{search}%"
      )
      .uniq
      .order(:created_at)
    else
      where(
        :id => nil
      )
      .uniq
      .order(:created_at)
    end
  end
end
