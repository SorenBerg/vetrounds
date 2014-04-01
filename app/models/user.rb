class User < ActiveRecord::Base
  require 'activity_aggregator'
  has_one :detail
  has_many :questions
  has_many :answers
  has_many :thanks, :foreign_key => 'from_id'
  has_many :thanked, :class_name => "Thank", :foreign_key => 'to_id'
  has_many :agreements, :foreign_key => 'from_id'
  has_many :agreed, :class_name => "Agreement", :foreign_key => 'to_id'
  accepts_nested_attributes_for :detail, allow_destroy: true

  before_save do
    email.downcase!
  end

  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 100 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :question_notification, inclusion: { in: %w(none all nearby), message: "%{value} is not a valid notification setting" }

  has_secure_password

  validates :password, length: { minimum: 6 }, :if => :validate_password?

  validates_acceptance_of :terms #terms of service checkbox

  mount_uploader :avatar, AvatarUploader
  #attr_accessible :avatar_cache

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def send_password_reset
    generate_unique_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def activity_stream
    # agree_stream = agreed.to_enum :find_each
    # thank_stream = thanked.to_enum :find_each
    # answer_stream = answers.to_enum :find_each
    # streams = [agree_stream, thank_stream, answer_stream]
    # ActivityAggregator.new(streams).next_activities(30)
    [answers, thanked, agreed].flatten.sort_by(&:updated_at).reverse.first(40)
  end


  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def validate_password?
      password.present? || password_confirmation.present?
    end

    def generate_unique_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
end
