class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :thanks
  has_many :agreements

  GENDER = { "Not sure" => 0, "Male" => 1, "Female" => 2 }
  SIGNALMENT = { "Not sure" => 0, "Spayed or Neutered" => 1, "Intact" => 2 }
  BREED = { "Not sure" => 0, "Specify breed" => 1 }

  validates :content, presence: true
  validates :gender, inclusion: { in: GENDER.values }
  validates :signalment, inclusion: { in: SIGNALMENT.values }
  validates :breed, inclusion: { in: BREED.values }
  validates_presence_of :breed_detail, :unless => lambda { self.breed == BREED["Not sure"] }
  validates :is_consult, :inclusion => {:in => [true, false]}
  validates :answered, :inclusion => {:in => [true, false]}

  def get_gender
    GENDER.key(read_attribute(:gender))
  end

  def get_signalment
    SIGNALMENT.key(read_attribute(:signalment))
  end

  def get_breed
    if read_attribute(:breed) == BREED["Not sure"]
      return "Unknown"
    else
      return read_attribute(:breed_detail)
    end
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
