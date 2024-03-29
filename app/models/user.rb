class User < ApplicationRecord
  paginates_per 10

  def rut=(value)
    value = Chilean::Rutify.format_rut(value)
    super(value)
  end

  # RUTify
  validates :rut, presence: true, uniqueness: { case_sensitive: true }, rut: true

  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name
    # user.username = auth.info.nickname # assuming the user model has a username
    # user.image = auth.info.image # assuming the user model has an image
    # If you are using confirmable and the provider(s) you use validate emails,
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation! unless auth.info.email.include?('@')
    end
  end

  def email_required?
    false
  end
end
