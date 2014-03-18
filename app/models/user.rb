class User < ActiveRecord::Base
  has_one :detail
  has_many :questions
  has_many :answers
  accepts_nested_attributes_for :detail, allow_destroy: true

  before_save do
    email.downcase!
  end

  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 100 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, length: { minimum: 6 }, :if => :validate_password?

  validates :terms, acceptance: true

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
