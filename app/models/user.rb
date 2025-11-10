class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_info, dependent: :destroy

  validates :email, presence: true,
                  uniqueness: { case_sensitive: false },
                  format: { with: URI::MailTo::EMAIL_REGEXP }

  accepts_nested_attributes_for :user_info
end
