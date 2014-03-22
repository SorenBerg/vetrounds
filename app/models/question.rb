class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :thanks
  has_many :agreements

  validates :content, presence: true

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
